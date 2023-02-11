import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:go_router_test/widgets/custom_image_fade.dart';

/// Signature used by [AppImage.errorBuilder] to build the widget that will be
/// displayed if an error occurs while loading an image.
typedef AppImageErrorBuilder = Widget Function(
  BuildContext context,
  Object exception,
);

/// Signature used by [AppImage.loadingBuilder] to build the widget that will be
/// displayed while an image is loading. `progress` returns a value between 0
/// and 1 indicating load progress.
typedef AppImageLoadingBuilder = Widget Function(
  BuildContext context,
  double progress,
  ImageChunkEvent? chunkEvent,
);

enum ImageType { asset, network, cachedNetwork }

// todo: add placeholder, defaultLoadingBuilder, defaultErrorBuilder

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.src,
    this.type = ImageType.cachedNetwork,
    this.placeholder,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 300),
    this.syncDuration = Duration.zero,
    this.width,
    this.height,
    this.scale = 1,
    this.fit = BoxFit.cover,
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
    this.aspectRatio,
    this.borderRadius,
    this.clipBehavior,
  });

  /// Image source.
  ///
  /// Can be an asset path or url path.
  final String src;

  /// Image Type used to set the ImageProvider.
  ///
  /// Can be `asset`, `network` or `cachedNetwork`.
  ///
  /// Defaults to `cashedNetwork`.
  final ImageType type;

  final Widget? placeholder;

  final Curve curve;

  final Duration duration;
  final Duration syncDuration;

  final double? width;
  final double? height;
  final double scale;
  final BoxFit fit;
  final Alignment alignment;
  final ImageRepeat repeat;
  final bool matchTextDirection;
  final bool excludeFromSemantics;
  final String? semanticLabel;
  final AppImageLoadingBuilder? loadingBuilder;
  final AppImageErrorBuilder? errorBuilder;
  final bool shouldOptimize;

  final int? maxWidth;
  final int? maxHeight;
  final double? aspectRatio;

  final BorderRadius? borderRadius;
  final Clip? clipBehavior;

  ImageProvider get _provider {
    switch (type) {
      case ImageType.asset:
        return AssetImage(src);
      case ImageType.network:
        return NetworkImage(src);
      case ImageType.cachedNetwork:
        return CachedNetworkImageProvider(
          src,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        );
    }
  }

  bool get _shouldOptimize =>
      maxWidth == null && maxHeight == null && shouldOptimize;

  @override
  Widget build(BuildContext context) {
    Widget current = LayoutBuilder(
      builder: (context, constraints) {
        return CustomImageFade(
          image: _provider,
          path: src,
          placeholder: placeholder,
          curve: curve,
          duration: duration,
          syncDuration: syncDuration,
          width: width,
          height: height,
          scale: scale,
          fit: fit,
          constraints: constraints,
          alignment: alignment,
          repeat: repeat,
          matchTextDirection: matchTextDirection,
          excludeFromSemantics: excludeFromSemantics,
          semanticLabel: semanticLabel,
          loadingBuilder: (context, progress, chunkEvent) {
            return Center(
              child: CircularProgressIndicator(
                value: progress,
              ),
            );
          },
          errorBuilder: errorBuilder,
          shouldOptimize: _shouldOptimize,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        );
      },
    );

    if (clipBehavior != null || borderRadius != null) {
      current = ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(50),
        clipBehavior: clipBehavior ?? Clip.antiAlias,
        child: current,
      );
    }

    if (aspectRatio != null) {
      current = AspectRatio(
        aspectRatio: aspectRatio!,
        child: current,
      );
    }

    return Center(child: current);
  }
}
