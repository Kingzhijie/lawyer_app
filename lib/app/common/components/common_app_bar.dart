import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/image_utils.dart';
import '../../utils/screen_utils.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool centerTitle;
  final double elevation;
  final String? actionName;
  final VoidCallback? onActionTap;
  final Widget? actions;
  final Widget? leftActionWidget;
  final Color? backgroundColor;
  final Color? leadingColor;
  final Color? titleColor;
  final bool isShowLeading;
  final VoidCallback? onLeadingTap;
  final double? titleSpacing;
  final Widget? titleWidget;
  final double? leadingWidth;
  final String? leftIconPath;
  final TextStyle? titleTextStyle;
  final Brightness barBrightness;
  final Color? bottomBarColor;

  const CommonAppBar({
    Key? key,
    this.title,
    this.centerTitle = true,
    this.barBrightness = Brightness.dark,
    this.bottomBarColor,
    this.elevation = 0,
    this.actionName,
    this.onActionTap,
    this.onLeadingTap,
    this.actions,
    this.backgroundColor,
    this.leadingColor,
    this.titleColor,
    this.isShowLeading = true,
    this.leftActionWidget,
    this.titleSpacing,
    this.titleWidget,
    this.leadingWidth,
    this.leftIconPath,
    this.titleTextStyle,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      leading:
          isShowLeading ? _popIcon(context) : (leftActionWidget ?? Container()),
      elevation: elevation,
      backgroundColor: backgroundColor ?? Colors.white,
      centerTitle: centerTitle,
      systemOverlayStyle: Platform.isIOS
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      surfaceTintColor: backgroundColor ?? Colors.white,
      titleSpacing: titleSpacing,
      leadingWidth:
          (!isShowLeading && leftActionWidget == null) ? 0 : leadingWidth,
      title: titleWidget ??
          Text(
            title ?? '',
            style: titleTextStyle ??
                TextStyle(
                    color: Colors.black,
                    fontSize: 18.toSp,
                    fontWeight: FontWeight.w600),
          ),
      actions: [
        actions ?? Container(),
      ],
    );
  }

  Widget _popIcon(BuildContext context) {
    return GestureDetector(
      onTap: onLeadingTap ??
          () {
            Navigator.maybePop(context);
          },
      child: Container(
        width: 50.toW,
        alignment: Alignment.center,
        child: ImageUtils(
          imageUrl: leftIconPath,
          width: 22.toW,
          height: 22.toW,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
