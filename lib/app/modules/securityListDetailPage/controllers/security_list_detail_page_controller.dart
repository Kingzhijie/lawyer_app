import 'package:get/get.dart';

class SecurityListDetailPageController extends GetxController {
  final caseInfo = <String, dynamic>{}.obs;
  final securityList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    caseInfo.value = {
      'title': '三诉讼李四合同纠纷案',
      'caseNumber': '2023粤0105民初1234号',
      'caseReason': '合同纠纷',
      'court': '广州市天河区人民法院',
      'parties': '张三(原告) 李四(被告)',
    };

    securityList.value = [
      {
        'target': '杭州韩秀美学医疗美容门诊部有限公司',
        'account': '工商银行帐户',
        'amount': '¥200,000.00',
        'dueDate': '2026年10月16日',
      },
      {
        'target': '杭州韩秀美学医疗美容门诊部有限公司',
        'account': '工商银行帐户',
        'amount': '¥200,000.00',
        'dueDate': '2026年10月16日',
      },
      {
        'target': '马星（个人）',
        'account': '工商银行帐户',
        'amount': '¥200,000.00',
        'dueDate': '2026年10月16日',
      },
      {
        'target': '马星（个人）',
        'account': '工商银行帐户',
        'amount': '¥200,000.00',
        'dueDate': '2026年10月16日',
      },
      {
        'target': '马星（个人）',
        'account': '工商银行帐户',
        'amount': '¥200,000.00',
        'dueDate': '2026年10月16日',
      },
    ];
  }
}
