import 'package:flutter/material.dart';

extension GlobalKeyExt on GlobalKey {
  /// 获取当前组件的 RenderBox
  RenderBox? renderBox() {
    RenderObject? renderObj = currentContext?.findRenderObject();
    if (renderObj == null || renderObj is! RenderBox) {
      return null;
    }
    RenderBox renderBox = renderObj;
    return renderBox;
  }

  /// 获取当前组件的 Offset
  Offset globalOffset() {
    if (renderBox() == null) {
      return Offset.zero;
    }
    var point = renderBox()!.localToGlobal(Offset.zero); //组件坐标
    return point;
  }

  /// 获取当前组件的 Size
  Size globalSize() {
    if (renderBox() == null) {
      return Size.zero;
    }
    return renderBox()!.size;
  }
}
