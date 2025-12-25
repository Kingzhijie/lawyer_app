import 'package:get/get.dart';

import '../controllers/search_case_page_controller.dart';

class SearchCasePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchCasePageController>(
      () => SearchCasePageController(),
    );
  }
}
