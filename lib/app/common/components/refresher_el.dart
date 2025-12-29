/// @Author: hpp
/// @Date: 2023-12-09
/// @Description: 下拉刷新组件

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../utils/screen_utils.dart';


class AppRefresher extends StatelessWidget {
  /// 子组件
  final Widget child;

  /// 刷新控制器
  final RefreshController controller;

  /// 下拉刷新
  final VoidCallback? onRefresh;

  /// 上拉加载更多
  final VoidCallback? onLoadMore;

  /// 是否显示下拉
  final bool enablePullDown;

  /// 底部没有更多了标题
  final String? bottomTitle;

  /// 是否显示上拉
  final bool enablePullUp;

  /// 加载更多的组件高度 默认为60+底部安全距离
  final double? loadFooterHeight;

  final Axis scrollDirection;

  final bool? reverse;

  /// 自定义foot
  final Widget? customFooter;

  const AppRefresher(
      {Key? key,
      required this.child,
      required this.controller,
      this.onRefresh,
      this.onLoadMore,
      this.bottomTitle,
      this.enablePullDown = true,
      this.enablePullUp = true,
      this.loadFooterHeight,
      this.scrollDirection = Axis.vertical, this.customFooter, this.reverse})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double footerHeight;
    if (loadFooterHeight != null) {
      footerHeight = loadFooterHeight!;
    } else {
      footerHeight = 20.toW + max(0, AppScreenUtil.bottomBarHeight);
    }
    Color color = AppColors.color_99000000;
    const double size = 20;
    return SmartRefresher(
      controller: controller,
      onRefresh: onRefresh,
      onLoading: onLoadMore,
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      scrollDirection: scrollDirection,
      reverse: reverse,
      header: ClassicHeader(
        idleText: scrollDirection == Axis.horizontal ? '右拉刷新' : '下拉刷新',
        idleIcon: Icon(
            scrollDirection == Axis.horizontal
                ? Icons.arrow_forward
                : Icons.arrow_downward,
            color: color,
            size: size),
        releaseText: '释放刷新',
        refreshingText: '刷新中',
        releaseIcon: Icon(Icons.refresh, color: color, size: size),
        completeText: '刷新完成',
        completeIcon: Icon(Icons.done, color: color, size: size),
        failedText: '刷新失败，下拉重试',
        failedIcon: null,
        spacing: 8,
        textStyle: TextStyle(color: color, fontSize: 12.toSp),
      ),
      footer: customFooter ?? ClassicFooter(
        idleText: '上拉加载',
        loadingText: '加载中...',
        idleIcon: Icon(Icons.arrow_upward, color: color, size: size),
        canLoadingText: '松手，加载更多',
        canLoadingIcon: Icon(Icons.refresh, color: color, size: size),
        failedText: '加载失败，上拉重试',
        failedIcon: null,
        noDataText: scrollDirection == Axis.horizontal
            ? '没有更多了'
            : bottomTitle ?? '- 没有更多内容了 -',
        noMoreIcon: null,
        spacing: 5.toW,
        textStyle: TextStyle(color: color, fontSize: 12.toSp),
        height: footerHeight,
        outerBuilder: (child) =>
            SizedBox(height: 20, child: Center(child: child)),
      ),
      child: child,
    );
  }
}
