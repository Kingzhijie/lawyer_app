import 'package:flutter/material.dart';

import 'src/pull_to_refresh_notification.dart';

double get maxDragOffset => 100;
double hideHeight = maxDragOffset / 2.3;
double refreshHeight = maxDragOffset / 1.5;

class PullToRefreshHeader extends StatelessWidget {
  const PullToRefreshHeader(
    this.info, {
    super.key,
    this.color,
  });

  final PullToRefreshScrollNotificationInfo? info;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final PullToRefreshScrollNotificationInfo? _info = info;
    if (_info == null) {
      return Container();
    }
    String text = '';
    if (_info.mode == PullToRefreshIndicatorMode.armed) {
      text = '释放刷新';
    } else if (_info.mode == PullToRefreshIndicatorMode.refresh ||
        _info.mode == PullToRefreshIndicatorMode.snap) {
      text = '加载中...';
    } else if (_info.mode == PullToRefreshIndicatorMode.done) {
      text = '刷新完成.';
    } else if (_info.mode == PullToRefreshIndicatorMode.drag) {
      text = '下拉刷新';
    } else if (_info.mode == PullToRefreshIndicatorMode.canceled) {
      text = '取消刷新';
    }

    final TextStyle ts = const TextStyle(
      color: Colors.grey,
    ).copyWith(fontSize: 14);

    final double dragOffset = info?.dragOffset ?? 0.0;

    final double top = -hideHeight + dragOffset;
    return Container(
      height: dragOffset,
      color: color ?? Colors.transparent,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0.0,
            right: 0.0,
            top: top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const PullToRefreshCupertinoActivityIndicator(
                      animating: true,
                      radius: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(text, style: ts),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
