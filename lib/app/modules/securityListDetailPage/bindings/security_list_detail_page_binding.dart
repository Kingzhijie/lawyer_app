import 'package:get/get.dart';

import '../controllers/security_list_detail_page_controller.dart';

class SecurityListDetailPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecurityListDetailPageController>(
      () => SecurityListDetailPageController(),
    );
  }
}
