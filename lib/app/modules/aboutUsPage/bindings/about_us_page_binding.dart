import 'package:get/get.dart';

import '../controllers/about_us_page_controller.dart';

class AboutUsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutUsPageController>(
      () => AboutUsPageController(),
    );
  }
}
