import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/app/utils/app_common_instance.dart';

import '../../../common/components/dialog.dart';
import '../../../utils/screen_utils.dart';

class MyPageController extends GetxController {
  //TODO: Implement MyPageController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  /// 退出登录
  void logout() {
    AppDialog.doubleItem(
      title: '温馨提示',
      titleStyle: TextStyle(
        color: Colors.black,
        fontSize: 17.toSp,
        fontWeight: FontWeight.w600,
      ),
      content: '是否确认退出登录?',
      contentStyle: TextStyle(color: Colors.black, fontSize: 15.toSp),
      cancel: '取消',
      confirm: '确认退出',
      onConfirm: () {
        AppCommonUtils.logout(isAlert: false);
      },
    ).showAlert();
  }

  ///关于我们
  void pushAboutUsPage() {
    Get.toNamed(Routes.ABOUT_US_PAGE);
  }

  ///邀请好友
  void pushInviteFriendPage() {
  }

  ///用户信息
  void pushUserInfoPage() {
    Get.toNamed(Routes.USER_INFO_PAGE);
  }
  
}
