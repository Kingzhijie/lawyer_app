import 'package:get/get.dart';

import '../controllers/edit_concerned_person_page_controller.dart';

class EditConcernedPersonPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditConcernedPersonPageController>(
      () => EditConcernedPersonPageController(),
    );
  }
}
