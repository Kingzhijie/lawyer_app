import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/modules/myPage/controllers/my_page_controller.dart';
import 'package:lawyer_app/app/modules/myPage/models/user_model.dart';
import 'package:lawyer_app/app/modules/myPage/views/my_page_view.dart';
import 'package:lawyer_app/app/modules/newHomePage/models/home_statistics.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/widgets/add_case_remark_widget.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/widgets/link_user_widget.dart';
import 'package:lawyer_app/app/modules/tabPage/controllers/tab_page_controller.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/main.dart';

import '../../../common/components/bottom_sheet_utils.dart';
import '../../../utils/screen_utils.dart';
import '../views/widgets/cooperation_person_widget.dart';
import '../views/widgets/create_case_widget.dart';

class NewHomePageController extends GetxController {
  /// 顶部筛选 tab 下标：0 我的待办、1 我参与的、2 已逾期
  final RxInt tabIndex = 0.obs;

  final TextEditingController textEditingController = TextEditingController();

  ///用户信息
  var userModel = Rx<UserModel?>(null);
  ///首页数据看板
  var homeStatistics = Rx<HomeStatistics?>(null);

  int pageNo = 1;

  final EasyRefreshController easyRefreshController= EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true
  );
  

  void switchTab(int index) {
    tabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void lookCalendarCaseAction() {
    getFindController<TabPageController>()?.changeIndex(2);
  }

  ///添加备注
  void addRemarkMethod() {
    textEditingController.text = '';
    BottomSheetUtils.show(currentContext,
        isShowCloseIcon: false,
        radius: 12.toW,
        contentWidget: AddCaseRemarkWidget(sendAction: (text){

        },textEditingController: textEditingController));
  }

  void linkUserAlert(){
    BottomSheetUtils.show(currentContext,
        radius: 12.toW,
        isShowCloseIcon: true,
        height: AppScreenUtil.screenHeight - 217.toW,
        isSetBottomInset: false,
        contentWidget: LinkUserWidget());
  }

  void searchCaseAction() {
    Get.toNamed(Routes.SEARCH_CASE_PAGE);
  }

  /// 打开我的页面底部抽屉
  void openMyPageDrawer() {
    getFindController<TabPageController>()?.openDrawer();
  }

  ///查看合同详情
  void lookContractDetailPage() {
    Get.toNamed(Routes.CONTRACT_DETAIL_PAGE);
  }

  ///获取用户信息
  void getUserInfo(){
    NetUtils.get(Apis.getUserInfo, isLoading: false).then((result){
      if (result.code == NetCodeHandle.success) {
        userModel.value = UserModel.fromJson(result.data);
        loadHomeStatistics();
      }
    });
  }

  ///加载首页数据看板
  void loadHomeStatistics(){
    NetUtils.get(Apis.homeStatistics, queryParameters: {'cycle': 1}, isLoading: false).then((result){
      if (result.code == NetCodeHandle.success) {
        if (result.data != null) {
          homeStatistics.value = HomeStatistics.fromJson(result.data);
        }
      }
    });
  }

  void onRefresh() {
    pageNo = 1;
    // getDynamicList(true);
    delay(1000, (){
      finishRefresh();
    });
  }

  void onLoadMore() {
    pageNo += 1;
    // getDynamicList(false);
    delay(1000, (){
      finishLoad(true);
    });
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
  

}
