import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../main.dart';
import '../../utils/image_utils.dart';
import '../../utils/screen_utils.dart';
/*
  * 底部弹框
  * radius: 圆角
  * height: 固定高度, 不设置自适应高度
  * isShowCloseIcon: 右上角是否显示关闭按钮
  * backgroundColor: 背景色
  * contentWidget: 底部弹出框内容widget
  * dismissCallBack: 页面关闭事件回调
  * 使用:
  * BottomSheetUtils.show(context, contentWidget: contentWidget, height: 200.h, dismissCallBack: (value){

    });
  * */
class BottomSheetUtils {
  static void show(BuildContext context,
      {double? radius,
      double? height,
      bool isShowCloseIcon = true,
      Color backgroundColor = Colors.white,
      Widget? contentWidget,
      bool isSetBottomInset = true,
      Function(dynamic value)? dismissCallBack}) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(radius ?? 0),
                topLeft: Radius.circular(radius ?? 0))),
        clipBehavior: Clip.antiAlias,
        backgroundColor: backgroundColor,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            height: height,
            color: backgroundColor,
            margin: isSetBottomInset
                ? EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom)
                : null, //解决键盘遮挡
            child: Stack(
              children: [
                Container(
                  constraints: height == null
                      ? BoxConstraints(
                          minHeight: 30.toW, //设置最小高度（必要）
                          maxHeight: MediaQuery.of(context).size.height -
                              AppScreenUtil.navigationBarHeight //设置最大高度（必要）
                          )
                      : null,
                  child: contentWidget,
                ),
                if (isShowCloseIcon)
                  Positioned(
                      top: 12.toW,
                      right: 10.toW,
                      child: InkWell(
                        child: Icon(
                            Icons.close,
                          size: 24.toW,
                          color: Colors.black,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ))
              ],
            ),
          );
        }).then((value) => {
          if (dismissCallBack != null) {dismissCallBack(value)}
        });
  }
}
