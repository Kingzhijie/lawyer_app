import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';

class SecurityListPageController extends GetxController {
  /// 当前选中的标签索引
  final selectedTabIndex = 0.obs;

  final TextEditingController textEditingController = TextEditingController();

  /// 筛选标签列表
  final filterTabs = [
    {'title': '全部(10)', 'key': 'all'},
    {'title': '60日到期(5)', 'key': '60'},
    {'title': '45日到期(3)', 'key': '45'},
    {'title': '30日到期(2)', 'key': '30'},
  ];

  /// 案件列表
  final caseList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCaseList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 加载案件列表
  void _loadCaseList() {
    // TODO: 从API加载数据
    // 示例数据
    caseList.value = [
      {
        'id': '1',
        'title': '张三诉讼李四合同纠纷案',
        'caseNumber': '2023粤0105民初1234号',
        'dueDate': '2026年10月16日',
        'assetCount': 8,
        'assets': {
          'realEstate': 2,
          'vehicles': 2,
          'funds': 29920.00,
        },
      },
      {
        'id': '2',
        'title': '张三诉讼李四合同纠纷案',
        'caseNumber': '2023粤0105民初1234号',
        'dueDate': '2026年10月16日',
        'assetCount': 8,
        'assets': {
          'realEstate': 2,
          'vehicles': 2,
          'funds': 299200.00,
        },
      },
    ];
  }

  /// 选择标签
  void selectTab(int index) {
    selectedTabIndex.value = index;
    // TODO: 根据选中的标签筛选数据
    _loadCaseList();
  }

  /// 搜索
  void searchAction() {
    // TODO: 实现搜索功能
  }


  /// 提醒操作
  void remindAction(Map<String, dynamic> caseInfo) {
    // TODO: 实现提醒功能
  }

  /// 添加备注
  void addNoteAction(Map<String, dynamic> caseInfo) {
    // TODO: 实现添加备注功能
  }

  void pushDetailPage() {
    Get.toNamed(Routes.SECURITY_LIST_DETAIL_PAGE);
  }

}
