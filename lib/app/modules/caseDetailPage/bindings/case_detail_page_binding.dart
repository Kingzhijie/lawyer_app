import 'package:get/get.dart';

import '../controllers/case_detail_page_controller.dart';

class CaseDetailPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CaseDetailPageController>(
      () => CaseDetailPageController(),
    );
  }
}
