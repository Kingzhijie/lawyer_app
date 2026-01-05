import 'package:get/get.dart';

import '../controllers/edit_case_base_info_controller.dart';

class EditCaseBaseInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditCaseBaseInfoController>(
      () => EditCaseBaseInfoController(),
    );
  }
}
