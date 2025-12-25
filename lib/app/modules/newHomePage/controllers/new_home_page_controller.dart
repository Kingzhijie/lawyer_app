import 'package:get/get.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/widgets/add_case_remark_widget.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/main.dart';

import '../../../common/components/bottom_sheet_utils.dart';
import '../../../utils/screen_utils.dart';

class NewHomePageController extends GetxController {
  /// 顶部筛选 tab 下标：0 我的待办、1 我参与的、2 已逾期
  final RxInt tabIndex = 0.obs;

  void switchTab(int index) {
    tabIndex.value = index;
  }

  void lookCalendarCaseAction() {
    Get.toNamed(Routes.CALENDAR_PAGE);
  }

  ///添加备注
  void addRemarkMethod() {
    BottomSheetUtils.show(currentContext,
        isShowCloseIcon: false,
        radius: 12.toW,
        contentWidget: AddCaseRemarkWidget());
  }

}
