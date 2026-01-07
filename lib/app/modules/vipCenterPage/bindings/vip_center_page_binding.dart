import 'package:get/get.dart';

import '../controllers/vip_center_page_controller.dart';

class VipCenterPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VipCenterPageController>(
      () => VipCenterPageController(),
    );
  }
}
