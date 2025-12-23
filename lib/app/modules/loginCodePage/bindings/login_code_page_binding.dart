import 'package:get/get.dart';

import '../controllers/login_code_page_controller.dart';

class LoginCodePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginCodePageController>(
      () => LoginCodePageController(),
    );
  }
}
