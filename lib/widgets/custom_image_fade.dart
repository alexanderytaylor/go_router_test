import 'dart:developer';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

/// Signature used by [ImageFade.errorBuilder] to build the widget that will be displayed
/// if an error occurs while loading an image.
typedef ImageFadeErrorBuilder = Widget Function(
  BuildContext context,
  Object exception,
);

/// Signature used by [ImageFade.loadingBuilder] to build the widget that will be displayed
/// while an image is loading. `progress` returns a value between 0 and 1 indicating load progress.
typedef ImageFadeLoadingBuilder = Widget Function(
  BuildContext context,
  double progress,
  ImageChunkEvent? chunkEvent,
);

/// A widget that displays a [placeholder] widget while a specified [image] loads,
/// then cross-fades to the loaded image. Can optionally display loading progress
/// and errors.
///
/// If [image] is subsequently changed, it will cross-fade to the new image once it
/// finishes loading.
///
/// Setting [image] to null will cross-fade back to the [placeholder].
///
/// ```dart
/// ImageFade(
///   placeholder: Image.asset('assets/myPlaceholder.png'),
///   image: NetworkImage('https://backend.example.com/image.png'),
/// )
/// ```
class CustomImageFade extends StatefulWidget {
  /// Creates a widget that displays a [placeholder] widget while a specified [image] loads,
  /// then cross-fades to the loaded image.
  const CustomImageFade({
    super.key,
    this.placeholder,
    this.image,
    required this.path,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 300),
    this.syncDuration,
    this.width,
    this.height,
    this.scale = 1,
    this.fit = BoxFit.cover,
    this.constraints,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.excludeFromSemantics = false,
    this.semanticLabel,
    this.loadingBuilder,
    this.errorBuilder,
    this.shouldOptimize = true,
    this.maxWidth,
    this.maxHeight,
  });

  /// Widget layered behind the loaded images. Displayed when [image] is null or is loading initially.
  final Widget? placeholder;

  /// The image to display. Subsequently changing the image will fade the new image over the previous one.
  final ImageProvider? image;

  final String path;

  /// The curve of the fade-in animation.
  final Curve curve;

  /// The duration of the fade-in animation.
  final Duration duration;

  /// An optional duration for fading in a synchronously loaded image (ex. from memory), error, or placeholder.
  /// For example, you could set this to `Duration.zero` to immediately display images that are already loaded.
  /// If omitted, [duration] will be used.
  final Duration? syncDuration;

  /// The width to display at. See [Image.width] for more information.
  final double? width;

  /// The height to display at. See [Image.height] for more information.
  final double? height;

  /// The scale factor for drawing this image at its intended size. See [RawImage.scale] for more information.
  final double scale;

  /// How to draw the image within its bounds. Defaults to [BoxFit.scaleDown]. See [Image.fit] for more information.
  final BoxFit fit;

  final BoxConstraints? constraints;

  /// How to align the image within its bounds. See [Image.alignment] for more information.
  final Alignment alignment;

  /// How to paint any portions of the layout bounds not covered by the image. See [Image.repeat] for more information.
  final ImageRepeat repeat;

  /// Whether to paint the image in the direction of the [TextDirection]. See [Image.matchTextDirection] for more information.
  final bool matchTextDirection;

  /// Whether to exclude this image from semantics. See [Image.excludeFromSemantics] for more information.
  final bool excludeFromSemantics;

  /// A Semantic description of the image. See [Image.semanticLabel] for more information.
  final String? semanticLabel;

  /// A builder that specifies the widget to display while an image is loading.
  /// See [ImageFadeLoadingBuilder] for more information.
  final ImageFadeLoadingBuilder? loadingBuilder;

  /// A builder that specifies the widget to display if an error occurs while an image is loading.
  /// This will be faded in over previous content, so you may want to set an opaque background on it.
  final ImageFadeErrorBuilder? errorBuilder;

  /// Whether the image should automatically be resized in the cache based on its
  /// size and the box constraints.
  ///
  /// Defaults to true.
  final bool shouldOptimize;

  final int? maxWidth;
  final int? maxHeight;

  @override
  State<StatefulWidget> createState() => _CustomImageFadeState();
}

class _CustomImageFadeState extends State<CustomImageFade>
    with TickerProviderStateMixin {
  _ImageResolver? _resolver;
  Widget? _front;
  Widget? _back;

  late final AnimationController _controller;
  Widget? _fadeFront;
  Widget? _fadeBack;

  bool? _sync; // could use onImage synchronousCall, but this is more forgiving
  bool _shouldBuildFront = false;

  OptimizedSize? _optimizedSize;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Can't call this in initState because createLocalImageConfiguration throws errors:
    _update(context);
  }

  @override
  void didUpdateWidget(CustomImageFade old) {
    // not called on init
    super.didUpdateWidget(old);
    _update(context, old);
  }

  void _update(BuildContext context, [CustomImageFade? old]) {
    final image = widget.image;
    final oldImage = old?.image;
    if (image == oldImage) return;

    _back = null;
    _shouldBuildFront = false;

    if (_resolver != null) {
      // move previous loaded image to back & cancel any active loads.
      if (_resolver!.complete) _back = _fadeBack = _front;
      _resolver!.dispose();
    }

    // load the new image:
    _front = _sync = null;
    _resolver = image == null
        ? null
        : _ImageResolver(
            provider: image,
            path: widget.path,
            context: context,
            onError: _handleComplete,
            onComplete: _handleComplete,
            onOptimizeSize: _handleOptimizeSize,
            width: widget.width,
            height: widget.height,
            constraints: widget.constraints,
            shouldOptimize: widget.shouldOptimize,
            fit: widget.fit,
            maxWidth: widget.maxWidth ?? _optimizedSize?.width,
            maxHeight: widget.maxHeight ?? _optimizedSize?.height,
          );

    // start transition to placeholder if there's no new image:
    if (_back != null && _resolver == null) _buildTransition();
  }

  void _handleComplete(_ImageResolver resolver) {
    _sync ??= true;
    // defer building the front content until build so we have an active context.
    setState(() => _shouldBuildFront = true);
  }

  void _handleOptimizeSize(OptimizedSize size) {
    _optimizedSize = size;
  }

  void _buildFront(BuildContext context) {
    _shouldBuildFront = false;
    final resolver = _resolver!;
    _front = resolver.error
        ? widget.errorBuilder?.call(context, resolver.exception!)
        : _getImage(resolver.image);
    _buildTransition();
  }

  void _buildTransition() {
    final out = _front == null; // no new image

    // use the "fast" duration if sync load, error, or placeholder:
    final fast = _sync != false || _resolver?.error == true || out;
    final duration = (fast ? widget.syncDuration : null) ?? widget.duration;

    // Fade in for duration, out for 1/2 as long:
    _controller.duration = duration * (out ? 1 : 3 / 2);

    _fadeFront = _buildFade(
      child: _front,
      opacity: CurvedAnimation(
        parent: _controller,
        curve: Interval(0, 2 / 3, curve: widget.curve),
      ),
    );

    _fadeBack = _buildFade(
      child: _back,
      opacity: Tween<double>(begin: 1, end: 0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(out ? 0.0 : 2 / 3, 1),
        ),
      ),
    );

    if (_front != null || _back != null) _controller.forward(from: 0);
  }

  Widget? _buildFade({Widget? child, required Animation<double> opacity}) {
    if (child == null) return null;
    // if the child is a loaded image, we can fade its opacity directly for better performance:
    return (child is RawImage)
        ? _getImage(child.image, opacity: opacity)
        : FadeTransition(opacity: opacity, child: child);
  }

  RawImage _getImage(ui.Image? image, {Animation<double>? opacity}) {
    return RawImage(
      image: image,
      width: widget.width,
      height: widget.height,
      scale: widget.scale,
      fit: widget.fit,
      alignment: widget.alignment,
      repeat: widget.repeat,
      matchTextDirection: widget.matchTextDirection,
      opacity: opacity,
    );
  }

  @override
  Widget build(BuildContext context) {
    _sync ??= false;
    if (_shouldBuildFront) _buildFront(context);
    var front = _fadeFront;
    final back = _fadeBack;

    final inLoad = _resolver != null && !_resolver!.complete;
    if (inLoad && widget.loadingBuilder != null) {
      final resolver = _resolver!;
      front = AnimatedBuilder(
        animation: resolver.notifier,
        builder: (_, __) => widget.loadingBuilder!(
          context,
          resolver.notifier.value,
          resolver.chunkEvent,
        ),
      );
    }

    final kids = <Widget>[];
    if (widget.placeholder != null) kids.add(widget.placeholder!);
    if (back != null) kids.add(back);
    if (front != null) kids.add(front);

    final content = SizedBox(
      width: widget.width,
      height: widget.height,
      child: kids.isEmpty
          ? null
          : Stack(fit: StackFit.passthrough, children: kids),
    );

    if (widget.excludeFromSemantics) return content;

    final label = widget.semanticLabel;
    return Semantics(
      container: label != null,
      image: true,
      label: label ?? '',
      child: content,
    );
  }

  @override
  void dispose() {
    _resolver?.dispose();
    _controller.dispose();
    super.dispose();
  }
}

// Simplifies working with image loading events and states.
class _ImageResolver {
  _ImageResolver({
    required this.context,
    required this.provider,
    required this.onComplete,
    required this.onError,
    required this.onOptimizeSize,
    required this.fit,
    required this.path,
    this.width,
    this.height,
    this.constraints,
    this.shouldOptimize = true,
    this.maxWidth,
    this.maxHeight,
  }) {
    _init();
  }

  Object? exception;
  ImageChunkEvent? chunkEvent;
  late final ValueNotifier<double> notifier;

  final void Function(_ImageResolver resolver) onComplete;
  final void Function(_ImageResolver resolver) onError;
  final ValueChanged<OptimizedSize> onOptimizeSize;

  late ImageStream _stream;
  late ImageStreamListener _listener;
  ImageInfo? _imageInfo;
  bool _complete = false;

  final BuildContext context;
  final ImageProvider provider;
  final String path;
  final double? width;
  final double? height;
  int? maxWidth;
  int? maxHeight;
  final BoxFit fit;
  BoxConstraints? constraints;
  bool shouldOptimize;
  bool _isOptimized = false;

  ImageConfiguration get _getConfig => createLocalImageConfiguration(
        context,
        size: width != null && height != null ? Size(width!, height!) : null,
      );

  ImageStreamListener get _getListener => ImageStreamListener(
        maxWidth == null && maxHeight == null && shouldOptimize && !_isOptimized
            ? _handleOptimize
            : _handleComplete,
        onChunk: _handleProgress,
        onError: _handleError,
      );

  ui.Image? get image => _imageInfo?.image;

  bool get complete => _complete;

  bool get error => exception != null;

  void _init() {
    log('init');
    _listener = _getListener;

    if (maxWidth == null && maxHeight == null) {
      _stream = provider.resolve(_getConfig);
    } else {
      if (provider is CachedNetworkImageProvider) {
        _stream = CachedNetworkImageProvider(
          path,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        ).resolve(_getConfig);
      } else {
        _stream = _resizeImage(width: maxWidth, height: maxHeight)
            .resolve(_getConfig);
      }
    }

    _stream.addListener(_listener); // Called sync if already completed.
    notifier = ValueNotifier(0);
  }

  void _handleComplete(ImageInfo imageInfo, bool sync) {
    log('complete');
    _imageInfo = imageInfo;
    _complete = true;
    onComplete(this);
  }

  void _handleProgress(ImageChunkEvent event) {
    chunkEvent = event;
    if (event.expectedTotalBytes == null) {
      notifier.value = 0.0;
    } else {
      final value = event.cumulativeBytesLoaded / event.expectedTotalBytes!;
      if (!shouldOptimize) {
        notifier.value = value;
      } else {
        if (!_isOptimized) {
          notifier.value = value / 2;
        } else {
          notifier.value = (value / 2) + 0.5;
        }
      }
    }
  }

  void _handleError(Object exc, StackTrace? _) {
    exception = exc;
    _complete = true;
    onError(this);
  }

  void _handleOptimize(ImageInfo imageInfo, bool sync) {
    log('optimize');
    _stream.removeListener(_listener);
    final size = _optimizeSize(imageInfo);
    maxWidth = size.width;
    maxHeight = size.height;

    onOptimizeSize(size);

    if (provider is CachedNetworkImageProvider) {
      _stream = CachedNetworkImageProvider(
        path,
        maxWidth: size.width,
        maxHeight: size.height,
      ).resolve(_getConfig);
    } else {
      _stream = _resizeImage(width: size.width, height: size.height)
          .resolve(_getConfig);
    }

    _isOptimized = true;
    _listener = _getListener;
    _stream.addListener(_listener);
  }

  /// Calculates the optimal cache dimensions of the image and returns a
  /// [ResizeImage] provider.
  OptimizedSize _optimizeSize(ImageInfo imageInfo) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final constraintsAspectRatio =
        constraints!.maxWidth / constraints!.maxHeight;
    final imageSize = Size(
        imageInfo.image.width.toDouble(), imageInfo.image.height.toDouble());
    final width = (constraints!.maxWidth * devicePixelRatio).round();
    final height = (constraints!.maxHeight * devicePixelRatio).round();

    switch (fit) {
      case BoxFit.fill:
        return OptimizedSize(width: width, height: height);
      case BoxFit.contain:
        final optimizeWidth = imageSize.aspectRatio > constraintsAspectRatio;
        return OptimizedSize(
          width: optimizeWidth ? width : null,
          height: optimizeWidth ? null : height,
        );
      case BoxFit.cover:
        final optimizeWidth = imageSize.aspectRatio < constraintsAspectRatio;
        return OptimizedSize(
          width: optimizeWidth ? width : null,
          height: optimizeWidth ? null : height,
        );
      case BoxFit.fitWidth:
        return OptimizedSize(width: width);
      case BoxFit.fitHeight:
        return OptimizedSize(height: height);
      case BoxFit.none:
        return const OptimizedSize();
      case BoxFit.scaleDown:
        if (imageSize.height < constraints!.maxHeight &&
            imageSize.width < constraints!.maxWidth) {
          return const OptimizedSize();
        }
        final optimizeWidth = imageSize.aspectRatio > constraintsAspectRatio;
        return OptimizedSize(
          width: optimizeWidth ? width : null,
          height: optimizeWidth ? null : height,
        );
    }
  }

  /// Wraps the [ImageProvider] in a [ResizeImage] provider.
  ResizeImage _resizeImage({int? width, int? height}) {
    return ResizeImage(provider, width: width, height: height);
  }

  void dispose() {
    _stream.removeListener(_listener);
  }
}

class OptimizedSize {
  const OptimizedSize({this.width, this.height});

  final int? width;
  final int? height;
}
