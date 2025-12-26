import 'package:get/get.dart';

import '../controllers/agency_center_page_controller.dart';

class AgencyCenterPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgencyCenterPageController>(
      () => AgencyCenterPageController(),
    );
  }
}
