import 'package:get/get.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/case_base_model.dart';
import 'package:lawyer_app/app/modules/contractDetailPage/models/case/pres_asset_model.dart';

class SecurityListDetailPageController extends GetxController {
  final caseInfo = Rx<CaseBaseModel?>(null);
  final securityList = <PresAssetModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments as int?;
    if (id != null) {
      getSecurityDetailInfo(id);
    }
  }

  void getSecurityDetailInfo(int id) async {
    NetUtils.get(
      Apis.preservationAssetDetail,
      queryParameters: {'id': id},
      isLoading: false,
    ).then((result) {
      if (result.code == NetCodeHandle.success) {
        caseInfo.value = CaseBaseModel.fromJson(result.data['caseInfo']);
        securityList.value = (result.data['preservationItems'] as List)
            .map((e) => PresAssetModel.fromJson(e))
            .toList();
      }
    });
  }

  // void _loadData() {
  //   caseInfo.value = {
  //     'title': '三诉讼李四合同纠纷案',
  //     'caseNumber': '2023粤0105民初1234号',
  //     'caseReason': '合同纠纷',
  //     'court': '广州市天河区人民法院',
  //     'parties': '张三(原告) 李四(被告)',
  //   };

  //   securityList.value = [
  //     {
  //       'target': '杭州韩秀美学医疗美容门诊部有限公司',
  //       'account': '工商银行帐户',
  //       'amount': '¥200,000.00',
  //       'dueDate': '2026年10月16日',
  //     },
  //     {
  //       'target': '杭州韩秀美学医疗美容门诊部有限公司',
  //       'account': '工商银行帐户',
  //       'amount': '¥200,000.00',
  //       'dueDate': '2026年10月16日',
  //     },
  //     {
  //       'target': '马星（个人）',
  //       'account': '工商银行帐户',
  //       'amount': '¥200,000.00',
  //       'dueDate': '2026年10月16日',
  //     },
  //     {
  //       'target': '马星（个人）',
  //       'account': '工商银行帐户',
  //       'amount': '¥200,000.00',
  //       'dueDate': '2026年10月16日',
  //     },
  //     {
  //       'target': '马星（个人）',
  //       'account': '工商银行帐户',
  //       'amount': '¥200,000.00',
  //       'dueDate': '2026年10月16日',
  //     },
  //   ];
  // }
}
