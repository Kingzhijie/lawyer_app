import 'package:get/get.dart';

import '../controllers/search_case_rsult_sub_page_controller.dart';

class SearchCaseRsultSubPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchCaseRsultSubPageController>(
      () => SearchCaseRsultSubPageController(),
    );
  }
}
