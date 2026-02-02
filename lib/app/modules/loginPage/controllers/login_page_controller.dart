import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';

class LoginPageController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final RxBool agreeProtocol = false.obs;
  final RxBool isSending = false.obs;

  void toggleAgree(bool? value) {
    agreeProtocol.value = value ?? false;
  }

  Future<void> sendCode() async {
    final phone = phoneController.text.trim();
    if (phone.length < 11) {
      showToast('请输入正确手机号');
      return;
    }
    if (!agreeProtocol.value) {
      showToast('请先勾选并同意协议');
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    isSending.value = true;
    NetUtils.post(
      Apis.sendSmsCode,
      params: {'mobile': phone, 'scene': 1},
      isLoading: false,
    ).then((data) {
      isSending.value = false;
      if (data.code == NetCodeHandle.success) {
        showToast('短信验证码已发送');
        Get.toNamed(Routes.LOGIN_CODE_PAGE, arguments: phone);
      }
    });
  }

  void lookProtocol(String text) {
    if (text == '《用户协议》') {
      Get.toNamed(
        Routes.WEB_VIEW_PAGE,
        arguments: {
          'title': '用户服务协议',
          'assetPath': 'assets/html/user_agreement.html',
        },
      );
    } else if (text == '《隐私政策》') {
      Get.toNamed(
        Routes.WEB_VIEW_PAGE,
        arguments: {
          'title': '隐私政策',
          'url': 'http://lingb.lawseek.cn/yszc.html',
        },
      );
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
