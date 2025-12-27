import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/tabPage/controllers/tab_page_controller.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../controllers/new_home_page_controller.dart';
import 'widgets/home_voice_widget.dart';
import 'widgets/overview_grid.dart';
import 'widgets/task_card.dart';

class NewHomePageView extends GetView<NewHomePageController> {
  const NewHomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _setFloatingActionWidget(),
      body: Stack(
        children: [
          // 背景
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: ImageUtils(
              imageUrl: Assets.home.homeBg.path,
              width: AppScreenUtil.screenWidth,
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: AppScreenUtil.bottomBarHeight + 80.toW,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.toW),
                    _buildOverviewTitle(),
                    SizedBox(height: 12.toW),
                    _buildOverviewGrid(),
                    SizedBox(height: 18.toW),
                    _buildTabs(),
                    SizedBox(height: 12.toW),
                  ],
                ).withMarginOnly(left: 16.toW, right: 16.toW),
                _buildTaskCardsList(),
                SizedBox(height: 24.toW),
              ],
            ),
          ).withMarginOnly(top: AppScreenUtil.navigationBarHeight + 50.toW),
          Positioned(
            top: 0,
            right: 16.toW,
            left: 16.toW,
            child: Column(
              children: [
                _buildTopBar(context),
                _buildSearchBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: AppScreenUtil.navigationBarHeight,
      padding: EdgeInsets.only(top: AppScreenUtil.statusBarHeight),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 34.toW,
            height: 34.toW,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.color_white.withOpacity(0.9),
            ),
            child: ClipOval(
              child: ImageUtils(
                imageUrl: Assets.home.defaultUserIcon.path,
              ),
            ),
          ).withOnTap(() {
            controller.openMyPageDrawer();
          }),
          Text(
            '灵伴',
            style: TextStyle(
              fontSize: 18.toSp,
              fontWeight: FontWeight.w600,
              color: AppColors.color_E6000000,
            ),
          ),
          SizedBox(width: 34.toW),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.toW, vertical: 10.toW),
          decoration: BoxDecoration(
            color: AppColors.color_white,
            borderRadius: BorderRadius.circular(12.toW),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            children: [
              ImageUtils(
                imageUrl: Assets.home.searchIcon.path,
                width: 18.toW,
                height: 18.toW,
              ),
              SizedBox(width: 8.toW),
              Text(
                '搜索案件',
                style: TextStyle(
                  fontSize: 14.toSp,
                  color: AppColors.color_FFC5C5C5,
                ),
              ),
            ],
          ),
        ).withOnTap((){
          controller.searchCaseAction();
        }).withExpanded(),
        Width(9.toW),
        Container(
          width: 44.toW,
          height: 44.toW,
          alignment: Alignment.center,
          child: ImageUtils(
            imageUrl: Assets.home.riliIcon.path,
            width: 25.toW,
            height: 25.toW,
          ),
        ).withOnTap((){
          controller.lookCalendarCaseAction();
        }),
      ],
    );
  }

  Widget _buildOverviewTitle() {
    return Text(
      '概览',
      style: TextStyle(
        fontSize: 17.toSp,
        fontWeight: FontWeight.w700,
        color: AppColors.color_E6000000,
      ),
    );
  }

  Widget _buildOverviewGrid() {
    return const OverviewGrid();
  }

  Widget _buildTabs() {
    final tabs = ['我的待办 (12)', '我参与的 (12)', '已逾期 (12)', '未逾期 (12)'];
    return Obx(() {
      final current = controller.tabIndex.value;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabs.length, (index) {
            final bool selected = current == index;
            return Padding(
              padding: EdgeInsets.only(right: 12.toW),
              child: GestureDetector(
                onTap: () => controller.switchTab(index),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.toW,
                    vertical: 8.toW,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.color_E6000000
                        : AppColors.color_FFF3F3F3,
                    borderRadius: BorderRadius.circular(8.toW),
                  ),
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 13.toSp,
                      fontWeight: FontWeight.w500,
                      color: selected
                          ? AppColors.color_white
                          : AppColors.color_99000000,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  Widget _buildTaskCardsList() {
    final items = List.generate(4, (index) => index);
    return ListView.builder(
      itemCount: items.length,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
      return TaskCard(clickItemType: (type) {
        if (type == 1){ //关联用户
          controller.linkUserAlert();
        }
        if (type == 0){ //备注
          controller.addRemarkMethod();
        }
      },).withMarginOnly(bottom: 12.toW);
    });
  }

  Widget _setFloatingActionWidget() {
    return Container(
      width: 52.toW,
      height: 52.toW,
      margin: EdgeInsets.only(bottom: AppScreenUtil.bottomBarHeight + 90.toW),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26.toW),
        color: AppColors.color_E6000000,
      ),
      alignment: Alignment.center,
      child: ImageUtils(imageUrl: Assets.home.voiceIcon.path, width: 30.toW),
    ).withOnTap((){
      getFindController<TabPageController>()?.pushChatPage();
    });
  }

}
