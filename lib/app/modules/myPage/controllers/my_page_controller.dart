import 'package:get/get.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';

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
    // TODO: 实现退出登录逻辑
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
