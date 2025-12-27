import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/modules/loginPage/controllers/login_page_controller.dart';
import 'package:lawyer_app/app/modules/loginPage/views/login_page_view.dart';
import 'package:lawyer_app/app/modules/myPage/views/my_page_view.dart';
import 'package:lawyer_app/app/modules/newHomePage/controllers/new_home_page_controller.dart';
import 'package:lawyer_app/app/modules/newHomePage/views/new_home_page_view.dart';
import 'package:lawyer_app/app/utils/app_common_instance.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../../../../launch_page.dart';
import '../../../common/components/keep_alive_wrapper.dart';
import '../../../common/constants/app_colors.dart';
import '../../agencyPage/controllers/agency_page_controller.dart';
import '../../agencyPage/views/agency_page_view.dart';
import '../../casePage/controllers/case_page_controller.dart';
import '../../casePage/views/case_page_view.dart';
import '../../chatPage/controllers/chat_page_controller.dart';
import '../../chatPage/views/chat_page_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home_view.dart';
import '../controllers/tab_page_controller.dart';

class TabPageView extends GetView<TabPageController> {
  const TabPageView({super.key});

  List<Widget> get _pages => [
    KeepAliveWrapper(
      child: GetBuilder<NewHomePageController>(
        init: NewHomePageController(),
        builder: (_) => const NewHomePageView(),
      ),
    ),
    KeepAliveWrapper(
      child: GetBuilder<ChatPageController>(
        init: ChatPageController(),
        builder: (_) => const ChatPageView(),
      ),
    ),
    Container(),
    KeepAliveWrapper(
      child: GetBuilder<CasePageController>(
        init: CasePageController(),
        builder: (_) => const CasePageView(),
      ),
    ),
    KeepAliveWrapper(
      child: GetBuilder<AgencyPageController>(
        init: AgencyPageController(),
        builder: (_) => const AgencyPageView(),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isFinishInit.value != true) {
        //首次
        return _setPlaceWidget();
      }

      if (!AppCommonUtils.isLogin) {
        return KeepAliveWrapper(
          child: GetBuilder<LoginPageController>(
            init: LoginPageController(),
            builder: (_) => const LoginPageView(),
          ),
        );
      }

      return Scaffold(
        key: controller.tabScaffoldKey,
        backgroundColor: AppColors.color_white,
        drawer: Drawer(
          clipBehavior: Clip.none,
          width: AppScreenUtil.screenWidth - 68.toW,
          child: MyPageView(),
        ),
        body: PageView(
          controller: controller.pageController,
          onPageChanged: controller.onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        extendBody: true,
        bottomNavigationBar: _buildBottomBar(context),
      );
    });
  }

  Widget _buildBottomBar(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.toW, 0, 10.toW, 8.toW),
        child: Container(
          height: 80.toW,
          padding: EdgeInsets.symmetric(horizontal: 14.toW),
          decoration: BoxDecoration(
            color: AppColors.color_white,
            borderRadius: BorderRadius.circular(40.toW),
            boxShadow: [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTabItem(index: 0, asset: Assets.tabbar.homeS.path),
              _buildTabItem(index: 1, asset: Assets.tabbar.chatN.path),
              _buildCenterButton(),
              _buildTabItem(index: 3, asset: Assets.tabbar.caseN.path),
              _buildTabItem(index: 4, asset: Assets.tabbar.waitN.path),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({required int index, required String asset}) {
    return Obx(() {
      final bool selected = controller.currentIndex.value == index;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => controller.changeIndex(index),
        child: Container(
          width: 52.toW,
          alignment: Alignment.center,
          child: ImageUtils(
            imageUrl: asset,
            width: 28.toW,
            height: 28.toW,
            imageColor: selected ? AppColors.theme : AppColors.color_FFC5C5C5,
          ),
        ),
      );
    });
  }

  Widget _buildCenterButton() {
    return GestureDetector(
      onTap: controller.onCenterTap,
      child: ImageUtils(
        imageUrl: Assets.tabbar.addCenter.path,
        width: 55.toW,
        height: 55.toW,
      ),
    );
  }

  /// 设置占位开屏图
  Widget _setPlaceWidget() {
    return LaunchPage(
      isFinishInit: controller.isFinishInit.value,
      agreeCallBack: () async {
        await controller.callBack();
      },
    );
  }
}
