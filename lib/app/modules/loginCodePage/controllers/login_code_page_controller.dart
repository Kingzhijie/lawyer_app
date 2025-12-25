import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/utils/storage_utils.dart';

import '../../../utils/app_common_instance.dart';

class LoginCodePageController extends GetxController {
  /// 传入的手机号码
  late final String phone;

  final RxInt countdown = 60.obs;
  Timer? _timer;

  /// 隐藏的验证码输入框控制器 & 焦点
  final TextEditingController codeController = TextEditingController();
  final FocusNode codeFocusNode = FocusNode();

  /// 当前验证码字符串（最多 4 位）
  final RxString code = ''.obs;

  /// 自定义光标是否可见
  final RxBool cursorVisible = true.obs;
  Timer? _cursorTimer;

  @override
  void onInit() {
    super.onInit();
    phone = Get.arguments ?? '';
    _startCountdown();

    codeController.addListener(() {
      var text = codeController.text;
      logPrint('验证码====$text');
      code.value = text;
      if (text.length == 4) {
        StorageUtils.setToken('token_test');
        Get.back();
        AppCommonUtils.changeTabHome();
      }
    });

    _cursorTimer = Timer.periodic(const Duration(milliseconds: 600), (_) {
      cursorVisible.value = !cursorVisible.value;
    });
  }

  @override
  void onReady() {
    super.onReady();
    // 页面展示后自动弹出键盘
    FocusScope.of(Get.context!).requestFocus(codeFocusNode);
  }

  @override
  void onClose() {
    _timer?.cancel();
    _cursorTimer?.cancel();
    codeController.dispose();
    codeFocusNode.dispose();
    super.onClose();
  }

  void _startCountdown() {
    countdown.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value <= 1) {
        timer.cancel();
        countdown.value = 0;
      } else {
        countdown.value--;
      }
    });
  }

  void resendCode() {
    if (countdown.value > 0) return;
    // TODO: 调用重新发送验证码接口
    _startCountdown();
  }

  /// 当前输入的完整验证码（最多 4 位）
  String get verifyCode => code.value;

  String get displayPhone => '+86 $phone';



}
