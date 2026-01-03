import 'package:get/get.dart';
import 'package:lawyer_app/app/modules/casePage/controllers/case_page_controller.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';

import '../../../common/components/tabPage/label_tab_bar.dart';
import '../../agencyCenterPage/controllers/agency_center_page_controller.dart';
import '../../agencyCenterPage/views/agency_center_page_view.dart';
import '../../casePage/views/case_page_view.dart';
import '../views/widget/case_base_info_content.dart';
import '../views/widget/case_document_widget.dart';
import '../views/widget/preservation_situation_widget.dart';

enum CaseDetailTypeEnum {
  baseInfo('基本案情', 0),
  bqqk('保全清单', 1),
  ajwd('案件文档', 2),
  rwzx('任务中心', 3);

  const CaseDetailTypeEnum(this.name, this.type);

  final String name;
  final int type;
}

class CaseDetailPageController extends GetxController {
  List<LabelTopBarModel> tabModelArr = [];

  List<CaseDetailTypeEnum> titles = [
    CaseDetailTypeEnum.baseInfo,
    CaseDetailTypeEnum.bqqk,
    CaseDetailTypeEnum.ajwd,
    CaseDetailTypeEnum.rwzx,
  ];

  // 当事人展开状态列表
  final RxList<bool> partyExpandedList = <bool>[false, true].obs;

  // 切换当事人展开状态
  void togglePartyExpanded(int index) {
    partyExpandedList[index] = !partyExpandedList[index];
  }

  @override
  void onInit() {
    super.onInit();

    tabModelArr = [
      LabelTopBarModel(
        CaseDetailTypeEnum.baseInfo.name,
        CaseBaseInfoContent(controller: this),
      ),
      LabelTopBarModel(
        CaseDetailTypeEnum.bqqk.name,
        PreservationSituationWidget(controller: this),
      ),
      LabelTopBarModel(
        CaseDetailTypeEnum.ajwd.name,
        CaseDocumentWidget(controller: this),
      ),
      LabelTopBarModel(
        CaseDetailTypeEnum.rwzx.name,
        AgencyCenterPageView(
          tag: CaseDetailTypeEnum.rwzx.type.toString(),
        ),
      ),
    ];

    Get.lazyPut<AgencyCenterPageController>(
      () => AgencyCenterPageController(),
      tag: CaseDetailTypeEnum.rwzx.type.toString(), // 使用 type 作为标签区分不同实例
      fenix: true, // 允许控制器被销毁后重新创建
    );
  }

  @override
  void onClose() {
    super.onClose();
    final tag = CaseDetailTypeEnum.rwzx.type.toString(); // 使用 type 作为 tag
    // 检查是否存在再删除
    if (Get.isRegistered<AgencyCenterPageController>(tag: tag)) {
      Get.delete<AgencyCenterPageController>(tag: tag, force: true);
    }
  }

  ///关联当事人
  void editConcernedPerson() {
    Get.toNamed(Routes.EDIT_CONCERNED_PERSON_PAGE);
  }

  ///代理律师费
  void attorneysFeePage() {
    Get.toNamed(Routes.ATTORNEYS_FEE_PAGE);
  }

}
