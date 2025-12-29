// @Author: hpp
// @Date: 2023-11-23
// @Description: 下拉刷新组件

import 'dart:async';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';

import '../../utils/screen_utils.dart';
import '../extension/widget_extension.dart';

/// 列表刷新组件
class MSEasyRefresher extends StatefulWidget {
  const MSEasyRefresher({
    super.key,
    this.controller,
    this.onLoad,
    this.onRefresh,
    required this.childBuilder,
    this.indicatorPosition = IndicatorPosition.above,
  });

  /// EasyRefreshController实例，用于控制刷新和加载的状态
  final EasyRefreshController? controller;

  /// 加载回调函数
  final FutureOr Function()? onLoad;

  /// 刷新回调函数
  final FutureOr Function()? onRefresh;

  /// 构建子组件的回调函数
  final Widget Function(BuildContext context, ScrollPhysics physics)
  childBuilder;

  /// 指示器的位置，默认为上方
  final IndicatorPosition indicatorPosition;

  @override
  State<MSEasyRefresher> createState() => _MSEasyRefresherState();
}

class _MSEasyRefresherState extends State<MSEasyRefresher> {
  @override
  Widget build(BuildContext context) {
    return EasyRefresh.builder(
      // 在开始刷新时立即触发刷新
      refreshOnStart: false,
      // 刷新完成后重置刷新状态
      resetAfterRefresh: true,
      // 同时触发刷新和加载的回调函数
      simultaneously: true,
      canLoadAfterNoMore: false,
      // 加载回调函数
      onLoad: widget.onLoad,
      // 刷新回调函数
      onRefresh: widget.onRefresh,
      // 指定刷新时的头部组件
      header: ClassicHeader(
        hitOver: true,
        safeArea: false,
        triggerOffset: 40,
        processedDuration: Duration.zero,
        showMessage: false,
        showText: true,
        position: widget.indicatorPosition,
        // 下面是一些文本配置
        processingText: "正在刷新...",
        readyText: "正在刷新...",
        armedText: "释放以刷新",
        dragText: "下拉刷新",
        processedText: "刷新成功",
        failedText: "刷新失败",
        iconTheme: IconThemeData(color: AppColors.color_FFC5C5C5),
        textStyle: TextStyle(
          color: AppColors.color_99000000,
          fontSize: 12.toSp,
        ),
      ),

      // 指定加载时的底部组件
      footer: ClassicFooter(
        hitOver: true,
        safeArea: true,
        showMessage: false,
        showText: true,
        processedDuration: Duration.zero,
        position: widget.indicatorPosition,
        // 下面是一些文本配置
        processingText: "加载中...",
        processedText: "加载成功",
        readyText: "加载中...",
        armedText: "释放以加载更多",
        dragText: "上拉加载",
        failedText: "加载失败",
        noMoreText: "没有更多内容",
        iconTheme: IconThemeData(color: AppColors.color_FFC5C5C5),
        textStyle: TextStyle(
          color: AppColors.color_99000000,
          fontSize: 12.toSp,
        ),
      ),
      controller: widget.controller,
      childBuilder: widget.childBuilder,
    );
  }
}

String zeroFill(int i) {
  return i >= 10 ? "$i" : "0$i";
}
