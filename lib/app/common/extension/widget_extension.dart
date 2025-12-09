/// @Author: hpp
/// @Date: 2023-11-03
/// @Description: 组件类扩展

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import '../../../main.dart';

/*
 ⭐️⭐️⭐️⭐️⭐️ 注意  ⭐️⭐️⭐️⭐️⭐️

 使用以下的时候的调用顺序
 withHeight >  withMarginAll >  withBackgroundColor >  withCircularRadius > withPaddingAll
  
*/

extension WidgetExtension on Widget {
  /// 设置外边距
  Widget withMargin(EdgeInsets margin) {
    return Container(margin: margin, child: this);
  }

  /// 设置外边距
  Widget withMarginOnly(
      {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    return Container(
        margin:
            EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
        child: this);
  }

  /// 设置外边距
  Widget withMarginSymmetric({double vertical = 0, double horizontal = 0}) {
    return Container(
        margin:
            EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
        child: this);
  }

  /// 设置外边距
  Widget withMarginAll(double value) {
    return Container(margin: EdgeInsets.all(value), child: this);
  }

  /// 设置内边距
  Widget withPadding(EdgeInsets padding) {
    return Padding(padding: padding, child: this);
  }

  /// 设置内边距
  Widget withPaddingOnly(
      {double left = 0, double top = 0, double right = 0, double bottom = 0}) {
    return Padding(
        padding:
            EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
        child: this);
  }

  /// 设置内边距
  Widget withPaddingSymmetric({double vertical = 0, double horizontal = 0}) {
    return Padding(
        padding:
            EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
        child: this);
  }

  /// 设置内边距
  Widget withPaddingAll(double value) {
    return Container(padding: EdgeInsets.all(value), child: this);
  }

  /// 设置背景色
  Widget withBackgroundColor(Color color) {
    return Container(color: color, child: this);
  }

  /// 设置高度
  Widget withHeight(double height) {
    return SizedBox(height: height, child: this);
  }

  /// 设置宽度
  Widget withWidth(double width) {
    return SizedBox(width: width, child: this);
  }

  /// 设置圆角
  Widget withCircularRadius(double radius) {
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: this);
  }

  /// 设置顶部圆角
  Widget withCircularTopRadius(double radius) {
    return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
        child: this);
  }

  ///设置底部圆角
  Widget withCircularBottomRadius(double radius) {
    return ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(radius),
          bottomRight: Radius.circular(radius),
        ),
        child: this);
  }

  /// 高斯模糊
  Widget withBackdropFilter(double sigmaX, double sigmaY, double radius) {
    return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
            child: this)
        .withCircularRadius(radius);
  }

  /// 设置是否显示
  Widget withVisible(bool visible) {
    return Visibility(visible: visible, child: this);
  }

  /// 设置透明度
  Widget withOpacity(double opacity) {
    return Opacity(opacity: opacity, child: this);
  }

  /// 设置点击事件
  Widget withOnTap(VoidCallback onTap,
      {HitTestBehavior? behavior = HitTestBehavior.opaque}) {
    return GestureDetector(onTap: onTap, behavior: behavior, child: this);
  }

  /// 设置长按事件
  Widget withOnLongPress(VoidCallback onLongPress,
      {HitTestBehavior? behavior = HitTestBehavior.opaque}) {
    return GestureDetector(
        onLongPress: onLongPress, behavior: behavior, child: this);
  }

  /// 设为扩展
  Widget withExpanded({int flex = 1}) {
    return Expanded(flex: flex, child: this);
  }

  /// 设为弹性
  Widget withFlexible({int flex = 1}) {
    return Flexible(flex: flex, child: this);
  }

  /// 设为滚动
  Widget withScrolled({ScrollPhysics? physics}) {
    return SingleChildScrollView(
      physics: physics,
      child: this,
    );
  }

  /// 设置点击时收起键盘
  Widget unfocusWhenTap() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: this,
    );
  }

  ///
  Widget setStatusBarStyle(
      {Brightness brightness = Brightness.dark,
      Color? bottomBarColor,
      BuildContext? context}) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Platform.isIOS
          ? (brightness == Brightness.dark
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light)
          : SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: brightness,
              statusBarIconBrightness: brightness,
              systemNavigationBarColor: bottomBarColor),
      child: this,
    );
  }
}
