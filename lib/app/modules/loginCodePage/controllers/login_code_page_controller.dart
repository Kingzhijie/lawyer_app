import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/storage_utils.dart';

import '../../../http/apis.dart';
import '../../../http/net/net_utils.dart';
import '../../../http/net/tool/error_handle.dart';
import '../../../utils/app_common_instance.dart';
import '../../../utils/toast_utils.dart';

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
      code.value = text;
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
    NetUtils.post(Apis.sendSmsCode, params: {'mobile': phone, 'scene':  1}).then((data) {
      if (data.code == NetCodeHandle.success) {
        showToast('短信验证码已发送');
        _startCountdown();
      }
    });
  }

  //登录
  void loginAction() {

    NetUtils.post(
      Apis.smsLogin,
      params: {
        'mobile': phone,
        'code': code.value,
        'cid': AppInfoUtils.instance.pushClientId,
      },
    ).then((data) {
      if (data.code == NetCodeHandle.success) {
        String accessToken = data.data['accessToken'].toString();
        String refreshToken = data.data['refreshToken'].toString();
        int expiresTime = data.data['expiresTime'] ?? 0; //毫秒
        if (!ObjectUtils.isEmptyString(accessToken)) {
          StorageUtils.setToken(accessToken);
          StorageUtils.setString(StorageKey.userId, data.data['userId'].toString());
          StorageUtils.setString(StorageKey.refreshToken, refreshToken);
          if (expiresTime >0) {
            StorageUtils.setInt(StorageKey.tokenExpiresTime, expiresTime);
          }
          Get.back();
          AppCommonUtils.changeTabHome();
        }
      }
    });
  }

  /// 当前输入的完整验证码（最多 4 位）
  String get verifyCode => code.value;

  String get displayPhone => '+86 $phone';
}
