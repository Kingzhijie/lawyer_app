/// @Author: hpp
/// @Date: 2023-11-10
/// @Description: 图片组件
/// @LastEditors: 新增asset、file图片类型

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import '../../main.dart';
import '../http/net/tool/logger.dart';
import 'object_utils.dart';

enum ImageUtilsType { network, local, asset, none }

// ignore: must_be_immutable
class ImageUtils extends StatelessWidget {
  /// 通用型图片
  ImageUtils({
    Key? key,
    required imageUrl,
    this.placeholderImagePath,
    this.placeholderError,
    this.fit,
    this.alignment,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.fadeInDuration,
    this.fadeInCurve,
    this.fadeOutDuration,
    this.fadeOutCurve,
    this.circularRadius,
    this.isAllShape,
    this.circularBottomLeft,
    this.circularBottomRight,
    this.circularTopLeft,
    this.circularTopRight,
    this.borderWidth,
    this.borderColor,
    this.imageColor,
    this.boxShadows,
    this.placeholderColor,
  })  : _url = imageUrl ?? '',
        super(key: key);

  /// 头像类图片
  ImageUtils.avatar({
    Key? key,
    required imageUrl,
    this.fit = BoxFit.cover,
    this.alignment,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.fadeInDuration,
    this.fadeInCurve,
    this.fadeOutDuration,
    this.fadeOutCurve,
    double? circularRadius,
    this.borderWidth,
    this.borderColor,
    this.imageColor,
    this.boxShadows,
    this.isAllShape,
    this.circularTopLeft,
    this.circularTopRight,
    this.circularBottomLeft,
    this.circularBottomRight,
    this.placeholderColor,
  })  : placeholderImagePath = '',
        placeholderError = '',
        circularRadius = circularRadius ?? (width ?? height ?? 0) / 2,
        _url = imageUrl ?? '',
        super(key: key);

  /// 占位图 默认通用占位图
  final String? placeholderImagePath;

  /// 加载失败占位图 默认通用失败图
  final String? placeholderError;

  /// 填充方式 默认为BoxFit.contain
  final BoxFit? fit;

  /// 宽
  final double? width;

  /// 高
  final double? height;

  /// 内边距
  final EdgeInsets? padding;

  /// 外边距
  final EdgeInsets? margin;

  /// 淡入动画时间 默认300毫秒
  final Duration? fadeInDuration;

  /// 淡入动画效果 默认Curves.easeIn
  final Curve? fadeInCurve;

  /// 淡出动画时间 默认300毫秒
  final Duration? fadeOutDuration;

  /// 淡出动画效果 默认Curves.easeOut
  final Curve? fadeOutCurve;

  /// 圆角
  final double? circularRadius;

  ///圆角的值是否用同一个
  final bool? isAllShape;

  /// 圆角
  final double? circularTopLeft;

  /// 圆角
  final double? circularTopRight;

  /// 圆角
  final double? circularBottomLeft;

  /// 圆角
  final double? circularBottomRight;

  /// 边框
  final double? borderWidth;

  /// 边框颜色
  final Color? borderColor;

  /// 阴影
  final List<BoxShadow>? boxShadows;

  /// 占位图背景颜色
  final Color? placeholderColor;

  /// 占位图背景颜色
  final Color? imageColor;

  /// 对齐方式
  final Alignment? alignment;

  /// 内存中的宽度
  int? _cacheWidth;

  /// 内存中的高度
  int? _cacheHeight;

  /// 图片链接
  String _url;

  late String tempUrl = '';

  late Widget _tempWidget = Container();

  @override
  Widget build(BuildContext context) {
    if (_url.isEmpty) {
      return _placeholderWidget(isErr: true);
    }

    ///增加缓存，如果有直接返回缓存image
    if (tempUrl.isNotEmpty) {
      return _tempWidget;
    }
    // 获取图片类型
    final imageType = getImageType(_url);
    tempUrl = _url;

    // 处理微信图片
    if (_url.contains('thirdwx.qlogo.cn') == true) {
      _url = _url.replaceFirst('thirdwx.qlogo.cn', 'wx.qlogo.cn');
    }

    Widget widget;

    switch (imageType) {
      case ImageUtilsType.network: // 网络图片
        {
          //此方式, 解决页面pop后图片闪的问题 <gaplessPlayback: true>
          // widget = Image(
          //   image: CachedNetworkImageProvider(_url,
          //       cacheManager: CustomCacheManager()),
          //   gaplessPlayback: true,
          //   width: width,
          //   height: height,
          //   color: imageColor,
          //   fit: _url.isNotEmpty ? (fit ?? BoxFit.cover) : BoxFit.cover,
          //   alignment: alignment ?? Alignment.center,
          //   errorBuilder: (context, error, stackTrace) =>
          //       _placeholderWidget(isErr: true),
          // );
          widget = CachedNetworkImage(
            imageUrl: _url,
            width: width,
            height: height,
            fit: fit ?? BoxFit.cover,
            alignment: alignment ?? Alignment.center,
            color: imageColor,
            placeholder: (context, url) => _placeholderWidget(),
            errorWidget: (context, url, error) {
              logPrint('error====$error---url===$url');
              return _placeholderWidget(isErr: true);
            },
            cacheManager: CustomCacheManager(),
            memCacheWidth: ObjectUtils.toPixelRatioInt(width), // 限制内存缓存尺寸
          );
        }
        break;
      case ImageUtilsType.asset: // 本地图片
        {
          widget = Image.asset(
                  _url,
                  width: width,
                  height: height,
                  color: imageColor,
                  cacheWidth: ObjectUtils.toPixelRatioInt(width),
                  fit: fit ?? BoxFit.cover,
                  alignment: alignment ?? Alignment.center,
                );
        }
        break;
      case ImageUtilsType.local: // 沙盒图片
        {
          if (kIsWeb) {
            // Web端用Image.network显示本地blob/base64图片
            widget = Image.network(
              _url,
              width: width,
              height: height,
              fit: fit ?? BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholderWidget(),
              alignment: alignment ?? Alignment.center,
            );
          } else {
            File file = File(_url);
            widget = Image.file(
              file,
              width: width,
              height: height,
              fit: fit ?? BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholderWidget(),
              alignment: alignment ?? Alignment.center,
            );
          }
        }
        break;
      case ImageUtilsType.none: // 空地址
        {
          widget = _placeholderWidget(isErr: true);
        }
        break;
    }

    // 图片添加圆角
    if ((circularRadius != null && circularRadius! > 0) ||
        !(isAllShape ?? true)) {
      widget = ClipRRect(
        borderRadius: isAllShape ?? true
            ? BorderRadius.all(Radius.circular(circularRadius ?? 0.0))
            : BorderRadius.only(
                topLeft: Radius.circular(circularTopLeft ?? 0.0),
                topRight: Radius.circular(circularTopRight ?? 0.0),
                bottomLeft: Radius.circular(circularBottomLeft ?? 0.0),
                bottomRight: Radius.circular(circularBottomRight ?? 0.0)),
        child: widget,
      );
    }

    _tempWidget = Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderWidth ?? 0,
          style: BorderStyle.solid,
        ),
        borderRadius: isAllShape ?? true
            ? BorderRadius.all(Radius.circular(circularRadius ?? 0.0))
            : BorderRadius.only(
                topLeft: Radius.circular(circularTopLeft ?? 0.0),
                topRight: Radius.circular(circularTopRight ?? 0.0),
                bottomLeft: Radius.circular(circularBottomLeft ?? 0.0),
                bottomRight: Radius.circular(circularBottomRight ?? 0.0)),
        boxShadow: boxShadows,
      ),
      child: widget,
    );
    return _tempWidget;
  }

  Widget _placeholderWidget({bool isErr = false}) {
    String imgPath =
        isErr ? (placeholderError ?? '') : (placeholderImagePath ?? '');
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: placeholderColor,
          borderRadius:
              BorderRadius.all(Radius.circular(circularRadius ?? 0.0))),
      child: imgPath.isEmpty
          ? null
          : Image.asset(
              imgPath,
              width: width,
              height: height,
              cacheWidth: ObjectUtils.toPixelRatioInt(width),
              fit: BoxFit.cover,
            ),
    );
  }

  /// 图片类型
  static ImageUtilsType getImageType(String url) {
    if (url.startsWith('http')) return ImageUtilsType.network;
    if (url.startsWith('assets')) return ImageUtilsType.asset;
    if (url.isNotEmpty) return ImageUtilsType.local;
    return ImageUtilsType.none;
  }

  setCacheSize(BuildContext context) {
    double scale = MediaQuery.of(context).devicePixelRatio;
    _cacheWidth ??= (width != null ? (width!).floor() : null);
    _cacheHeight ??= (height != null ? (height!).floor() : null);
    if (_cacheWidth != null) {
      _cacheWidth = (_cacheWidth! * scale).floor();
    }

    if (_cacheHeight != null) {
      _cacheHeight = (_cacheHeight! * scale).floor();
    }
  }

}

/// 自定义设置缓存管理器
class CustomCacheManager extends CacheManager {
  static const key = 'customCache';

  static CustomCacheManager? _instance;

  factory CustomCacheManager() {
    if (_instance == null) {
      _instance = CustomCacheManager._();
    }
    return _instance!;
  }

  CustomCacheManager._()
      : super(Config(
          key,
          stalePeriod: const Duration(days: 7), // 设置缓存过期时间
          maxNrOfCacheObjects: 100, // 设置最大缓存对象数量
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: HttpFileService(),
        ));

  @override
  Future<String> getFilePath() async {
    final directory = await getTemporaryDirectory();
    return directory.path + key;
  }
}
