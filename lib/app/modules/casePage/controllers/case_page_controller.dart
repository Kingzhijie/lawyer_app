import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/modules/newHomePage/controllers/new_home_page_controller.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/widgets/link_user_widget.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/app/utils/loading.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';

import '../../../../main.dart';
import '../../../common/components/bottom_sheet_utils.dart';
import '../../../http/apis.dart';
import '../../../http/net/net_utils.dart';
import '../../../http/net/tool/error_handle.dart';
import '../../../utils/object_utils.dart';
import '../../../utils/screen_utils.dart';
import '../../newHomePage/views/widgets/create_case_widget.dart';
import '../../tabPage/controllers/tab_page_controller.dart';
import '../models/case_base_info_model.dart';

class CasePageController extends GetxController {
  final RxInt tabIndex = 0.obs;

  int pageNo = 1;

  final EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  final caseBaseInfoList = RxList<CaseBaseInfoModel>([]);

  @override
  void onInit() {
    super.onInit();
    LoadingTool.showLoading();
    getCaseListData(true);
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
    LoadingTool.showLoading();
    getCaseListData(true);
  }

  void openMyPageDrawer() {
    getFindController<TabPageController>()?.openDrawer();
  }

  //创建案件
  void createCaseAction() {
    BottomSheetUtils.show(
      currentContext,
      radius: 12.toW,
      isShowCloseIcon: true,
      height: AppScreenUtil.screenHeight - 217.toW,
      isSetBottomInset: false,
      contentWidget: CreateCaseWidget(
        createCaseSuccess: () {
          getCaseListData(true);
        },
      ),
    );
  }

  ///获取数据
  Future<void> getCaseListData(bool isRefresh) async {
    Map<String, dynamic> parameters = {
      'page': pageNo,
      'pageSize': 10,
      'status': tabIndex.value == 0
          ? null
          : (tabIndex.value - 1), //0-待更新 1-进行中 2-已归档, null: 全部
    };
    var result = await NetUtils.get(
      Apis.caseBasicInfoList,
      isLoading: false,
      queryParameters: parameters,
    );
    LoadingTool.dismissLoading();
    if (result.code == NetCodeHandle.success) {
      var list = (result.data['list'] as List)
          .map((e) => CaseBaseInfoModel.fromJson(e))
          .toList();
      if (isRefresh) {
        caseBaseInfoList.value = list;
        finishRefresh();
      } else {
        caseBaseInfoList.value.addAll(list);
      }
      bool isNoMore = caseBaseInfoList.length >= result.data['total'];
      delay(500, () {
        finishLoad(isNoMore);
      });
    } else {
      finishRefresh();
      finishLoad(true);
    }
  }

  void onRefresh() async {
    pageNo = 1;
    await getCaseListData(true);
  }

  void onLoadMore() async {
    pageNo += 1;
    await getCaseListData(false);
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

  ////查看案件详情
  void lookCaseDetail(CaseBaseInfoModel model) {
    Get.toNamed(Routes.CONTRACT_DETAIL_PAGE, arguments: model.id);
  }

  void onLinkUser() {
    final userModel =
        getFindController<NewHomePageController>()?.userModel.value;
    if (userModel == null) {
      return;
    }

    // if (userModel.hasTeamOffice == false) {
    //   Get.toNamed(Routes.VIP_CENTER_PAGE);
    //   return;
    // }

    BottomSheetUtils.show(
      currentContext,
      radius: 12.toW,
      isShowCloseIcon: true,
      height: AppScreenUtil.screenHeight - 217.toW,
      isSetBottomInset: false,
      contentWidget: LinkUserWidget(),
    );
  }
}
