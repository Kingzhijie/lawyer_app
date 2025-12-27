import 'package:get/get.dart';

import '../controllers/user_info_page_controller.dart';

class UserInfoPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserInfoPageController>(
      () => UserInfoPageController(),
    );
  }
}
