import 'package:flutter/material.dart';

class CustomScrollPhysics extends ClampingScrollPhysics {
  final CustomScrollPhysicsController controller;

  const CustomScrollPhysics({
    super.parent,
    required this.controller,
  });

  /// 必须实现的方法
  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(
      parent: buildParent(ancestor),
      controller: controller,
    );
  }

  /// 返回值，确定要限制滑动的距离
  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    // 处理 禁止左滑或右滑
    final lastSwipePosition = controller._lastSwipePosition;
    if (lastSwipePosition != null) {
      // 手势往左滑 value值会越来越大，往右滑 value会越来越小
      // 此时将要往左滑   但禁止往左滑
      if (value > lastSwipePosition && controller.banSwipeLeft) {
        // 返回要限制的滑动距离 抵消滑动
        return value - position.pixels;
      }
      // 此时将要往右滑 但禁止往右滑
      if (value < lastSwipePosition && controller.banSwipeRight) {
        // 返回要限制的滑动距离 抵消滑动
        return value - position.pixels;
      }
    }
    controller._lastSwipePosition = value;

    return super.applyBoundaryConditions(position, value);
  }
}

class CustomScrollPhysicsController {
  // 禁止左滑或右滑
  late bool banSwipeRight;
  late bool banSwipeLeft;

  // 记录 CustomScrollPhysics 滑动的值
  double? _lastSwipePosition;

  CustomScrollPhysicsController({
    this.banSwipeRight = false,
    this.banSwipeLeft = false,
  });
}
