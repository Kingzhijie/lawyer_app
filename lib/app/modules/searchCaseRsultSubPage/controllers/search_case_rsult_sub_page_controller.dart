import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/bottom_sheet_utils.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/modules/newHomePage/models/case_task_model.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/widgets/add_case_remark_widget.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';
import 'package:lawyer_app/main.dart';

class SearchCaseRsultSubPageController extends GetxController {
  int? type;
  String? searchText;
  SearchCaseRsultSubPageController({this.type, this.searchText});

  final RxList<CaseTaskModel> caseTaskList = <CaseTaskModel>[].obs;
  int pageNo = 1;
  final TextEditingController textEditingController = TextEditingController();
  late final EasyRefreshController easyRefreshController;

  @override
  void onInit() {
    super.onInit();
    easyRefreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    getCaseTaskListData(true);
  }

  Future<void> getCaseTaskListData(bool isRefresh) async {
    int? partyRole;
    if (type == 1) {
      partyRole = 1;
    } else if (type == 2) {
      partyRole = 2;
    }

    Map<String, dynamic> parameters = {
      'page': pageNo,
      'pageSize': 10,
      if (searchText != null) 'title': searchText,
      if (partyRole != null) 'partyRole': partyRole,
    };
    var result = await NetUtils.get(
      Apis.getTaskPage,
      isLoading: false,
      queryParameters: parameters,
    );
    if (result.code == NetCodeHandle.success) {
      var list = (result.data['list'] as List)
          .map((e) => CaseTaskModel.fromJson(e))
          .toList();
      if (isRefresh) {
        caseTaskList.value = list;
        finishRefresh();
      } else {
        caseTaskList.value.addAll(list);
      }
      bool isNoMore = caseTaskList.length >= result.data['total'];
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
    getCaseTaskListData(true);
  }

  void onLoadMore() {
    pageNo += 1;
    getCaseTaskListData(false);
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

  void onContractDetail(num? caseId) {
    Get.toNamed(Routes.CONTRACT_DETAIL_PAGE, arguments: caseId);
  }

  void addRemarkAction(CaseTaskModel model) {
    textEditingController.text = '';
    BottomSheetUtils.show(
      currentContext,
      isShowCloseIcon: false,
      radius: 12.toW,
      contentWidget: AddCaseRemarkWidget(
        sendAction: (text) => setTaskRemark(text, model),
        textEditingController: textEditingController,
      ),
    );
  }

  ///设置备注
  void setTaskRemark(String text, CaseTaskModel model) {
    if (text.isEmpty) {
      showToast('请输入备注');
      return;
    }
    NetUtils.post(
      Apis.setTaskRemark,
      params: {'content': text, 'id': model.id},
    ).then((result) {
      if (result.code == NetCodeHandle.success) {
        showToast('备注添加成功');
        Get.back();
      }
    });
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }
}
