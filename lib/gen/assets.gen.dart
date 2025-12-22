// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsCommonGen {
  const $AssetsCommonGen();

  /// File path: assets/common/app_logo.png
  AssetGenImage get appLogo =>
      const AssetGenImage('assets/common/app_logo.png');

  /// File path: assets/common/launch_img.png
  AssetGenImage get launchImg =>
      const AssetGenImage('assets/common/launch_img.png');

  /// List of all assets
  List<AssetGenImage> get values => [appLogo, launchImg];
}

class $AssetsTabbarGen {
  const $AssetsTabbarGen();

  /// File path: assets/tabbar/add_center.png
  AssetGenImage get addCenter =>
      const AssetGenImage('assets/tabbar/add_center.png');

  /// File path: assets/tabbar/case_n.png
  AssetGenImage get caseN => const AssetGenImage('assets/tabbar/case_n.png');

  /// File path: assets/tabbar/chat_n.png
  AssetGenImage get chatN => const AssetGenImage('assets/tabbar/chat_n.png');

  /// File path: assets/tabbar/home_s.png
  AssetGenImage get homeS => const AssetGenImage('assets/tabbar/home_s.png');

  /// File path: assets/tabbar/wait_n.png
  AssetGenImage get waitN => const AssetGenImage('assets/tabbar/wait_n.png');

  /// List of all assets
  List<AssetGenImage> get values => [addCenter, caseN, chatN, homeS, waitN];
}

class Assets {
  const Assets._();

  static const $AssetsCommonGen common = $AssetsCommonGen();
  static const $AssetsTabbarGen tabbar = $AssetsTabbarGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
    this.animation,
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;
  final AssetGenImageAnimation? animation;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({AssetBundle? bundle, String? package}) {
    return AssetImage(_assetName, bundle: bundle, package: package);
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class AssetGenImageAnimation {
  const AssetGenImageAnimation({
    required this.isAnimation,
    required this.duration,
    required this.frames,
  });

  final bool isAnimation;
  final Duration duration;
  final int frames;
}
