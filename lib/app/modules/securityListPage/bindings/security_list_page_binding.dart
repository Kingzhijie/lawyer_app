import 'package:get/get.dart';

import '../controllers/security_list_page_controller.dart';

class SecurityListPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecurityListPageController>(() => SecurityListPageController());
  }
}
