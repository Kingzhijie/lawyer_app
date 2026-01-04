import 'package:get/get.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/case_detail_model.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case_timeline_model.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';

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
}
