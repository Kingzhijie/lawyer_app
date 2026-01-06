import 'package:get/get.dart';

import '../controllers/case_page_controller.dart';

class CasePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CasePageController>(() => CasePageController());
  }
}
