import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/modules/securityListPage/models/assets_tab_count_model.dart';
import 'package:lawyer_app/app/modules/securityListPage/models/security_item_model.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';

class SecurityListPageController extends GetxController {
  /// 当前选中的标签索引
  final selectedTabIndex = 0.obs;

  final TextEditingController textEditingController = TextEditingController();

  var assetsTabCountModel = Rx<AssetsTabCountModel?>(null);
  int pageNo = 1;

  final EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  /// 案件列表
  final securityList = <SecurityItemModel>[].obs;
  String keyword = '';

  @override
  void onInit() {
    super.onInit();
    getAssetTabCount();
    onRefresh();
  }

  void getAssetTabCount() {
    NetUtils.get(Apis.preservationAssetTabCount, isLoading: false).then((
      result,
    ) {
      if (result.code == NetCodeHandle.success) {
        assetsTabCountModel.value = AssetsTabCountModel.fromJson(result.data);
      }
    });
  }

  ///获取数据
  Future<void> getCaseListData(bool isRefresh) async {
    int? expiryDays;
    if (selectedTabIndex.value == 1) {
      expiryDays = 60;
    } else if (selectedTabIndex.value == 2) {
      expiryDays = 45;
    } else if (selectedTabIndex.value == 3) {
      expiryDays = 30;
    }

    Map<String, dynamic> parameters = {
      'page': pageNo,
      'pageSize': 10,
      if (keyword.isNotEmpty) 'keyword': keyword,
      if (expiryDays != null) 'expiryDays': expiryDays,
    };
    var result = await NetUtils.get(
      Apis.preservationAssetList,
      isLoading: false,
      queryParameters: parameters,
    );
    if (result.code == NetCodeHandle.success) {
      var list = (result.data['list'] as List)
          .map((e) => SecurityItemModel.fromJson(e))
          .toList();
      if (isRefresh) {
        securityList.value = list;
        finishRefresh();
      } else {
        securityList.value.addAll(list);
      }
      bool isNoMore = securityList.length >= result.data['total'];
      delay(500, () {
        finishLoad(isNoMore);
      });
    } else {
      finishRefresh();
      finishLoad(true);
    }
  }

  void onRefresh() {
    pageNo = 1;
    getCaseListData(true);
  }

  void onLoadMore() {
    pageNo += 1;
    getCaseListData(false);
  }

  /// 下拉刷新完成
  void finishRefresh() {
    easyRefreshController.finishRefresh();
    easyRefreshController.resetFooter();
  }

  /// 上拉加载完成
  void finishLoad(bool isLast) {
    if (isLast) {
      easyRefreshController.finishLoad(IndicatorResult.noMore);
    } else {
      easyRefreshController.finishLoad();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 选择标签
  void selectTab(int index) {
    selectedTabIndex.value = index;
    onRefresh();
  }

  /// 搜索
  void searchAction() {
    keyword = textEditingController.text;
    onRefresh();
  }

  /// 提醒操作
  void remindAction(Map<String, dynamic> caseInfo) {
    // TODO: 实现提醒功能
  }

  /// 添加备注
  void addNoteAction(Map<String, dynamic> caseInfo) {
    // TODO: 实现添加备注功能
  }

  void pushDetailPage(SecurityItemModel item) {
    Get.toNamed(Routes.SECURITY_LIST_DETAIL_PAGE, arguments: item.caseId);
  }
}
