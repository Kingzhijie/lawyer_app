import 'package:get/get.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';

class NewHomePageController extends GetxController {
  /// 顶部筛选 tab 下标：0 我的待办、1 我参与的、2 已逾期
  final RxInt tabIndex = 0.obs;

  void switchTab(int index) {
    tabIndex.value = index;
  }

  void lookCalendarCaseAction() {
    Get.toNamed(Routes.CALENDAR_PAGE);
  }

}
