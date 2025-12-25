import 'package:get/get.dart';

import '../controllers/search_case_result_page_controller.dart';

class SearchCaseRsultPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchCaseResultPageController>(
      () => SearchCaseResultPageController(),
    );
  }
}
