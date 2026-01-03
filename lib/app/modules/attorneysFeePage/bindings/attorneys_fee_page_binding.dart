import 'package:get/get.dart';

import '../controllers/attorneys_fee_page_controller.dart';

class AttorneysFeePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttorneysFeePageController>(
      () => AttorneysFeePageController(),
    );
  }
}
