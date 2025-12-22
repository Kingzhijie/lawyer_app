import 'package:get/get.dart';

import '../controllers/agency_page_controller.dart';

class AgencyPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgencyPageController>(
      () => AgencyPageController(),
    );
  }
}
