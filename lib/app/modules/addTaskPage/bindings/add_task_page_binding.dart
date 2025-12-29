import 'package:get/get.dart';

import '../controllers/add_task_page_controller.dart';

class AddTaskPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddTaskPageController>(
      () => AddTaskPageController(),
    );
  }
}
