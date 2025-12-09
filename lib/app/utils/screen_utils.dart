import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ExtensionNum on num {
  /// 宽度适配
  double get toW {
    return w;
  }

  /// 高度适配
  double get toH {
    return h;
  }

  // 字体适配
  double get toSp {
    return sp;
  }

  // 圆角
  double get toR {
    return r;
  }
}

class AppScreenUtil {
  /// 默认适配屏幕大小
  static Size defaultSize = const Size(375, 812);

  /// 状态栏的高度
  static double get statusBarHeight {
    return ScreenUtil().statusBarHeight;
  }

  /// 导航栏的高度
  static double navigationBarHeight = statusBarHeight + kToolbarHeight;

  /// 底部栏安全区距离的高度
  static double get bottomBarHeight {
    return ScreenUtil().bottomBarHeight;
  }
  /// 屏幕高度
  static double screenHeight = ScreenUtil().screenHeight;

  /// 屏幕宽度
  static double screenWidth = ScreenUtil().screenWidth;

  /// 屏幕像素密度
  static double? pixelRatio = ScreenUtil().pixelRatio;
}

class Width extends SizedBox {
  const Width(double width, {Key? key}) : super(key: key, width: width);
}

class Height extends SizedBox {
  const Height(double height, {Key? key}) : super(key: key, height: height);
}
