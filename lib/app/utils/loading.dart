import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/*
* Loading加载工具
* loading框: LoadingTool.showLoading()
* */
class LoadingTool {
  // loading框
  static showLoading({bool dismissOnTap = true}) {
    if (!EasyLoading.isShow) {
      EasyLoading.show(dismissOnTap: dismissOnTap);
    }
  }

  //成功toast
  static showSuccess({
    required String msg,
    int closeTime = 2,
  }) {
    EasyLoading.showSuccess(msg, duration: Duration(seconds: closeTime));
  }

  //错误toast
  static showError({
    required String msg,
    int closeTime = 2,
  }) {
    EasyLoading.showError(msg, duration: Duration(seconds: closeTime));
  }

  //进度loading
  static showProgress({
    required double progress,
  }) {
    EasyLoading.showProgress(progress,
        status: '${(progress * 100).toStringAsFixed(0)}%');
    if (progress >= 1) {
      EasyLoading.dismiss();
    }
  }

  // 消失loading框
  static dismissLoading() {
    EasyLoading.dismiss();
  }

  //loading基础配置 -可根据UI设计修改 配置
  static configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..maskType = EasyLoadingMaskType.custom
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 20.0
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = Colors.black
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.transparent
      ..userInteractions = true
      ..dismissOnTap = true;
  }
}
