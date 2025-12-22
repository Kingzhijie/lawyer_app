import 'package:get/get.dart';

import '../controllers/new_home_page_controller.dart';

class NewHomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewHomePageController>(
      () => NewHomePageController(),
    );
  }
}
