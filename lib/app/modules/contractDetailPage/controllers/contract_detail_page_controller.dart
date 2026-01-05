import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/bottom_sheet_utils.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/case_detail_model.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case_timeline_model.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/views/contract_detail_page_view.dart';
import 'package:lawyer_app/app/modules/newHomePage/controllers/new_home_page_controller.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/widgets/link_user_widget.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';
import 'package:lawyer_app/main.dart';

class ContractDetailPageController extends GetxController {
  final RxInt trialIndex = 0.obs; // 0-一审, 1-二审, 2-再审
  num? caseId;
  var caseDetail = Rx<CaseDetailModel?>(null);
  var caseTimelineList = <CaseTimelineModel>[].obs;

  void switchTrial(int index) {
    trialIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    caseId = Get.arguments;
    if (caseId != null) {
      getContractDetailInfo();
      getCaseTimelineList();
    }
  }

  void getContractDetailInfo() async {
    NetUtils.get(
      Apis.caseBasicInfo,
      queryParameters: {'id': caseId},
      isLoading: false,
    ).then((result) {
      if (result.code == NetCodeHandle.success) {
        caseDetail.value = CaseDetailModel.fromJson(result.data ?? {});
        if (caseDetail.value != null) {
          trialIndex.value = caseDetail.value!.caseBase!.caseProcedure! > 0
              ? caseDetail.value!.caseBase!.caseProcedure! - 1
              : 0;
        }
      }
    });
  }

  void getCaseTimelineList() async {
    NetUtils.get(
      Apis.caseTimeline,
      queryParameters: {'caseId': caseId},
      isLoading: false,
    ).then((result) {
      if (result.code == NetCodeHandle.success) {
        caseTimelineList.value = (result.data as List)
            .map((e) => CaseTimelineModel.fromJson(e))
            .toList();
      }
    });
  }

  void addTask() {
    Get.toNamed(Routes.ADD_TASK_PAGE);
  }

  void onLinkUser() {
    final userModel =
        getFindController<NewHomePageController>()?.userModel.value;
    if (userModel == null) {
      return;
    }

    if (userModel.hasTeamOffice == false) {
      showToast('跳转引导开会员');
      return;
    }

    BottomSheetUtils.show(
      currentContext,
      radius: 12.toW,
      isShowCloseIcon: true,
      height: AppScreenUtil.screenHeight - 217.toW,
      isSetBottomInset: false,
      contentWidget: LinkUserWidget(),
    );
  }

  void onCaseDetail({required int tabIndex}) {
    Get.toNamed(
      Routes.CASE_DETAIL_PAGE,
      arguments: {'caseId': caseId, 'tabIndex': tabIndex},
    );
  }

  void uploadFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // 所有类型
        allowMultiple: false, // 单选
      );
      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        logPrint('文件名: ${file.name}');
        logPrint('文件大小: ${file.size} bytes');
        logPrint('文件路径: ${file.path}');
        logPrint('文件扩展名: ${file.extension}');

        NetUtils.uploadSingleFile(file.path!).then((result) {
          logPrint('result====$result--');

          /// todo : 上传文件到该案件
        });
      }
    } catch (e) {
      logPrint('选取错误===$e');
    }
  }

  // 处理菜单操作
  void handleMenuAction(String action) {
    if (action == CaseActionType.caseClosed.title) {
      // 结案
      logPrint('结案操作');
    } else if (action == CaseActionType.caseArchiving.title) {
      // 结案
      logPrint('归档操作');
    } else if (action == CaseActionType.caseAppeal.title) {
      // 结案
      logPrint('上诉操作');
    }else if (action == CaseActionType.caseDelete.title) {
      // 结案
      logPrint('删除操作');
    }

  }
}
