import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../common/components/bottom_sheet_utils.dart';
import '../../../utils/object_utils.dart';
import '../../../utils/screen_utils.dart';
import '../../newHomePage/views/widgets/create_case_widget.dart';
import '../../tabPage/controllers/tab_page_controller.dart';

class CasePageController extends GetxController {

  final RxInt tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void switchTab(int index) {
    tabIndex.value = index;
  }


  void openMyPageDrawer() {
    getFindController<TabPageController>()?.openDrawer();
  }

  //创建案件
  void createCaseAction() {
    BottomSheetUtils.show(currentContext,
        radius: 12.toW,
        isShowCloseIcon: true,
        height: AppScreenUtil.screenHeight - 217.toW,
        isSetBottomInset: false,
        contentWidget: CreateCaseWidget());
  }

}
