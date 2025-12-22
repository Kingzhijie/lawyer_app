import 'package:get/get.dart';

import '../controllers/tab_page_controller.dart';

class TabPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabPageController>(
      () => TabPageController(),
    );
  }
}
