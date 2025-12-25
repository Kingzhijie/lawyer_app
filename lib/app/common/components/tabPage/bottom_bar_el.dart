/// @Author: hpp
/// @Date: 2021-11-15
/// @Description: 默认UI样式的页面底部固定栏 适配安全距离
/// @LastEditors:
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class YDBottomBar extends StatelessWidget {
  /// 底部固定栏 适配安全距离
  const YDBottomBar({
    Key? key,
    required this.context,
    this.width,
    this.child,
    this.padding,
    this.margin,
    this.radius,
    this.hideTopLine = false,
    this.backgroundColor,
  }) : super(key: key);

  final double? width;
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? radius;
  final BuildContext context;
  // 隐藏顶部分割线
  final bool hideTopLine;
  final Color? backgroundColor;

  /// 底部填充背景的单个按钮的构造方法 默认黑色背景样式
  YDBottomBar.fillButton({
    Key? key,
    required String title,
    required VoidCallback? onPressed,
    this.width,
    this.padding,
    this.margin,
    this.radius,
    this.backgroundColor,
    this.hideTopLine = false,
    required this.context,
    TextStyle? titleStyle,
    Color? titleColor,
  })  : child = Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(radius ?? 0.5),
              ),
              color:
                  backgroundColor ?? Theme.of(context).colorScheme.onSurface),
          child: TextButton(
              onPressed: onPressed,
              style: const ButtonStyle().copyWith(
                  overlayColor: MaterialStateProperty.all(Colors.transparent)),
              child: Text(title,
                  style: titleStyle ??
                      TextStyle(
                          color: titleColor ??
                              Theme.of(context).colorScheme.primaryContainer,
                          fontSize: 28.sp))),
        ),
        super(key: key);

  /// 底部单个线框按钮的构造方法 默认黑色线框白色背景样式
  YDBottomBar.outlineButton({
    Key? key,
    required String title,
    required VoidCallback? onPressed,
    this.width,
    this.padding,
    this.margin,
    this.radius,
    this.backgroundColor,
    this.hideTopLine = false,
    required this.context,
    Color? titleColor,
  })  : child = Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(radius ?? 0.5),
              ),
              color: backgroundColor ??
                  Theme.of(context).colorScheme.primaryContainer),
          child: TextButton(
              onPressed: onPressed,
              style: const ButtonStyle().copyWith(
                  overlayColor: MaterialStateProperty.all(Colors.transparent)),
              child: Text(title,
                  style: TextStyle(
                      color: titleColor ??
                          Theme.of(context).colorScheme.primaryContainer,
                      fontSize: 28.sp))),
        ),
        super(key: key);

  /// 底部两个按钮的构造方法
  YDBottomBar.doubleButton({
    Key? key,
    required String leftTitle,
    required String rightTitle,
    required VoidCallback? onLeftPressed,
    required VoidCallback? onRightPressed,
    this.width,
    this.padding,
    this.margin,
    this.radius,
    required this.context,
    this.backgroundColor,
    this.hideTopLine = false,
  })  : child = Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(radius ?? 0.5),
                    ),
                    color: Theme.of(context).colorScheme.primaryContainer),
                child: TextButton(
                    onPressed: onLeftPressed,
                    style: const ButtonStyle().copyWith(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    child: Text(
                      leftTitle,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          fontSize: 28.sp),
                    )),
              ),
            ),
            Container(width: 40.w),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(radius ?? 0.5),
                    ),
                    color: Theme.of(context).colorScheme.primaryContainer),
                child: TextButton(
                    onPressed: onRightPressed,
                    style: const ButtonStyle().copyWith(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    child: Text(
                      rightTitle,
                      style: TextStyle(fontSize: 28.sp),
                    )),
              ),
            )
          ],
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? ScreenUtil().screenWidth,
      decoration: hideTopLine
          ? const BoxDecoration()
          : BoxDecoration(
              color: backgroundColor ??
                  Theme.of(context).colorScheme.primaryContainer,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 0.5,
                  style: BorderStyle.solid,
                ),
              )),
      margin: margin ??
          EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      padding: padding ?? EdgeInsets.fromLTRB(40.w, 18.w, 40.w, 18.w),
      child: child,
    );
  }
}
