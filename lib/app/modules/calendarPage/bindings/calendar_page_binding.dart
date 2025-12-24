import 'package:get/get.dart';

import '../controllers/calendar_page_controller.dart';

class CalendarPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalendarPageController>(
      () => CalendarPageController(),
    );
  }
}
