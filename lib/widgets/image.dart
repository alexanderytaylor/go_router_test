import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _defaultPlaceholderImage = 'assets/movie_placeholder.png';

/// {@template app_image_frame_builder}
/// App Image Frame Builder
///
/// TODO: Add description
/// {@endtemplate}
typedef FrameBuilder = Widget Function(
  BuildContext,
  Widget,
  int?,
  bool,
)?;

/// {@template app_image_loading_builder}
/// App Image Loading Builder
///
/// TODO: Add description
/// {@endtemplate}
typedef LoadingBuilder = Widget Function(
  BuildContext,
  Widget,
  ImageChunkEvent?,
)?;

/// {@template app_image_error_builder}
/// App Image Error Builder
///
/// TODO: Add description
/// {@endtemplate}
typedef ErrorBuilder = Widget Function(
  BuildContext,
  Object,
  StackTrace?,
)?;

/// {@template image_size}
/// Image Size
///
/// TODO: Add description
/// {@endtemplate}
class ImageSize {
  /// {@macro image_size}
  const ImageSize({this.width, this.height});

  /// Image Width
  final int? width;

  /// Image Height
  final int? height;
}

/// {@template app_image}
/// App Image
///
/// TODO: Add description
/// {@endtemplate}
class AppImage extends StatefulWidget {
  /// {@macro app_image}
  const AppImage({
    required this.path,
    this.borderRadius,
    this.clipBehavior,
    this.aspectRatio,
    this.duration = const Duration(microseconds: 300),
    this.placeholderImage,
    this.placeholderWidget,
    this.showPlaceholder = true,
    this.showLoadingProgressIndicator = false,
    // ----------------
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.width,
    this.height,
    this.color,
    this.opacity,
    this.colorBlendMode,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.centerSlice,
    this.matchTextDirection = false,
    this.gaplessPlayback = false,
    this.filterQuality = FilterQuality.low,
    this.isAntiAlias = false,
    this.headers,
    // todo: make sure this overrides the inside ones when its set
    this.cacheWidth,
    this.cacheHeight,
    super.key,
  }) : assert(
          (placeholderImage != null && placeholderWidget == null) ||
              (placeholderImage == null && placeholderWidget != null) ||
              (placeholderImage == null && placeholderWidget == null),
          'either imagePlaceholder OR widgetPlaceholder must be null',
        );

  // TODO(@alexanderytaylor): add factory constructors for creating specific AppImages with predefined placeholders. for exampel movie, book, tv etc.
  // TODO(@alexanderytaylor): probably need to create some sort of extension method to accomplish the above.

  /// Image path URL
  final String path;

  /// The border radius of the rounded corners.
  ///
  /// Values are clamped so that horizontal and vertical radii sums do not
  /// exceed width/height.
  final BorderRadius? borderRadius;

  /// {@macro flutter.rendering.ClipRectLayer.clipBehavior}
  ///
  /// Defaults to [Clip.antiAlias].
  final Clip? clipBehavior;

  final double? aspectRatio;

  final String? placeholderImage;

  final Widget? placeholderWidget;

  /// The duration over which to fade in the image on load.
  ///
  /// Defaults to 300 milliseconds
  final Duration duration;

  /// Whether to show an image placeholder while the image loads.
  ///
  /// Defaults to true.
  final bool showPlaceholder;

  /// A builder that specifies the widget to display to the user while an image
  /// is still loading.
  ///
  /// Defaults to false.
  final bool showLoadingProgressIndicator;

  /// A builder function responsible for creating the widget that represents
  /// this image.
  ///
  /// If null, shows the placeholder and fades in the image when it loads.
  final FrameBuilder? frameBuilder;

  /// A builder that specifies the widget to display to the user while an image
  /// is still loading.
  ///
  /// If null, defaults to a circular progress indicator.
  final LoadingBuilder? loadingBuilder;

  /// A builder function that is called if an error occurs during image loading.
  ///
  /// If null, shows the placeholder on an exception.
  final ErrorBuilder? errorBuilder;

  final String? semanticLabel;
  final bool excludeFromSemantics;

  /// If non-null, require the image to have this width.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio.
  final double? width;

  /// If non-null, require the image to have this height.
  ///
  /// If null, the image will pick a size that best preserves its intrinsic
  /// aspect ratio.
  final double? height;
  final Color? color;
  final Animation<double>? opacity;
  final BlendMode? colorBlendMode;

  /// How to inscribe the image into the space allocated during layout.
  ///
  /// Defaults to [BoxFit.cover].
  final BoxFit fit;
  final Alignment alignment;
  final ImageRepeat repeat;
  final Rect? centerSlice;
  final bool matchTextDirection;
  final bool gaplessPlayback;
  final FilterQuality filterQuality;
  final bool isAntiAlias;
  final Map<String, String>? headers;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  State<AppImage> createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> {
  Size? placeholderImageSize;
  Size? networkImageSize;

  ImageSize? _getOptimizedSize(
    BoxFit fit,
    BoxConstraints constraints,
    Size? imageSize,
    double devicePixelRatio,
  ) {
    if (imageSize == null) return const ImageSize();
    final width = (constraints.maxWidth * devicePixelRatio).toInt();
    final height = (constraints.maxHeight * devicePixelRatio).toInt();
    switch (fit) {
      case BoxFit.fill:
        return ImageSize(width: width, height: height);
      case BoxFit.contain:
        final constraintsAspectRatio =
            constraints.maxWidth / constraints.maxHeight;
        final imageAspectRatio = imageSize.width / imageSize.height;
        final optimizeWidth = imageAspectRatio > constraintsAspectRatio;
        return ImageSize(
          width: optimizeWidth ? width : null,
          height: optimizeWidth ? null : height,
        );
      case BoxFit.cover:
        final constraintsAspectRatio =
            constraints.maxWidth / constraints.maxHeight;
        final imageAspectRatio = imageSize.width / imageSize.height;
        final optimizeWidth = imageAspectRatio < constraintsAspectRatio;
        return ImageSize(
          width: optimizeWidth ? width : null,
          height: optimizeWidth ? null : height,
        );
      case BoxFit.fitWidth:
        return ImageSize(width: width);
      case BoxFit.fitHeight:
        return ImageSize(height: height);
      case BoxFit.none:
        return const ImageSize();
      case BoxFit.scaleDown:
        if (imageSize.height < constraints.maxHeight &&
            imageSize.width < constraints.maxWidth) {
          return const ImageSize();
        }
        final constraintsAspectRatio =
            constraints.maxWidth / constraints.maxHeight;
        final imageAspectRatio = imageSize.width / imageSize.height;
        final optimizeWidth = imageAspectRatio > constraintsAspectRatio;
        return ImageSize(
          width: optimizeWidth ? width : null,
          height: optimizeWidth ? null : height,
        );
    }
  }

  Future<void> _getAssetImageSize() async {
    final bytes = await rootBundle
        .load(widget.placeholderImage ?? _defaultPlaceholderImage);
    final decodedImage = await decodeImageFromList(bytes.buffer.asUint8List());
    if (mounted) {
      setState(() {
        placeholderImageSize =
            Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());
      });
    }
  }

  Future<void> _getNetworkImageSize() async {
    final completer = Completer<Size>();
    NetworkImage(widget.path).resolve(ImageConfiguration.empty).addListener(
      ImageStreamListener((image, _) {
        if (mounted) {
          setState(() {
            completer.complete(
              networkImageSize = Size(
                image.image.width.toDouble(),
                image.image.height.toDouble(),
              ),
            );
          });
        }
      }),
    );
  }

  void _calcImageSize() {
    if (widget.placeholderWidget == null) {
      _getAssetImageSize();
    }
    _getNetworkImageSize();
  }

  @override
  void initState() {
    _calcImageSize();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _calcImageSize();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant AppImage oldWidget) {
    _calcImageSize();
    super.didUpdateWidget(oldWidget);
  }

  // todo? Do I need to use

  @override
  Widget build(BuildContext context) {
    Widget current = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

        final placeholderSize = _getOptimizedSize(
          widget.fit,
          constraints,
          placeholderImageSize,
          devicePixelRatio,
        );

        final placeholder = widget.placeholderWidget ??
            Image.asset(
              widget.placeholderImage ?? _defaultPlaceholderImage,
              fit: widget.fit,
              cacheWidth: widget.cacheWidth ?? placeholderSize?.width,
              cacheHeight: widget.cacheHeight ?? placeholderSize?.height,
            );

        final networkSize = _getOptimizedSize(
          widget.fit,
          constraints,
          networkImageSize,
          devicePixelRatio,
        );

        return Image.network(
          widget.path,
          frameBuilder: widget.frameBuilder ??
              (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) return child;
                return Stack(
                  fit: StackFit.passthrough,
                  children: [
                    placeholder,
                    Positioned.fill(
                      child: AnimatedOpacity(
                        opacity: frame == null ? 0 : 1,
                        duration: widget.duration,
                        child: child,
                      ),
                    ),
                  ],
                );
              },
          loadingBuilder: !widget.showLoadingProgressIndicator
              ? null
              : widget.loadingBuilder ??
                  (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Stack(
                      fit: StackFit.passthrough,
                      children: [
                        child,
                        AppCircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ],
                    );
                  },
          errorBuilder: widget.errorBuilder ??
              (context, error, stackTrace) {
                log(
                  'AppImage error loading:',
                  error: error,
                  stackTrace: stackTrace,
                );
                return placeholder;
              },
          semanticLabel: widget.semanticLabel,
          excludeFromSemantics: widget.excludeFromSemantics,
          width: widget.width,
          height: widget.height,
          color: widget.color,
          opacity: widget.opacity,
          colorBlendMode: widget.colorBlendMode,
          fit: widget.fit,
          alignment: widget.alignment,
          repeat: widget.repeat,
          centerSlice: widget.centerSlice,
          matchTextDirection: widget.matchTextDirection,
          gaplessPlayback: widget.gaplessPlayback,
          filterQuality: widget.filterQuality,
          isAntiAlias: widget.isAntiAlias,
          headers: widget.headers,
          cacheWidth: widget.cacheWidth ?? networkSize?.width,
          cacheHeight: widget.cacheHeight ?? networkSize?.height,
        );
      },
    );

    current = ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(50),
      clipBehavior: widget.clipBehavior ?? Clip.antiAlias,
      child: current,
    );

    if (widget.aspectRatio != null) {
      current = AspectRatio(
        aspectRatio: widget.aspectRatio!,
        child: current,
      );
    }

    return Center(child: current);
  }
}

class AppCircularProgressIndicator extends StatelessWidget {
  const AppCircularProgressIndicator({super.key, this.value});

  final double? value;

  @override
  Widget build(BuildContext context) {
    // TODO: add max size? use constrained box?
    // todo: change color and width
    return Center(
      child: CircularProgressIndicator(
        value: value,
      ),
    );
  }
}
