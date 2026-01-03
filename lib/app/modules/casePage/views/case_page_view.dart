import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lawyer_app/app/modules/newHomePage/controllers/new_home_page_controller.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';

import '../../../../gen/assets.gen.dart';
import '../../../common/components/common_app_bar.dart';
import '../../../common/components/easy_refresher.dart';
import '../../../common/components/empty_content_widget.dart';
import '../../../common/constants/app_colors.dart';
import '../../../common/extension/widget_extension.dart';
import '../../../utils/image_utils.dart';
import '../../../utils/screen_utils.dart';
import '../../addTaskPage/views/widgets/add_task_item.dart';
import '../controllers/case_page_controller.dart';

class CasePageView extends GetView<CasePageController> {
  const CasePageView({super.key});

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
          _buildTopBar(context),
          Positioned(
            left: 0,
            right: 0,
            top: AppScreenUtil.navigationBarHeight,
            child: _buildTabs(),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(
              top: AppScreenUtil.navigationBarHeight + 48.toW,
            ),
            child: Obx(() {
              if (controller.caseBaseInfoList.isEmpty) {
                return EmptyContentWidget();
              }

              return MSEasyRefresher(
                controller: controller.easyRefreshController,
                onRefresh: () {
                  controller.onRefresh();
                },
                onLoad: () {
                  controller.onLoadMore();
                },
                childBuilder: (context, physics) {
                  return ListView.builder(
                    itemCount: controller.caseBaseInfoList.length,
                    physics: physics,
                    padding: EdgeInsets.only(
                      left: 16.toW,
                      right: 16.toW,
                      top: 8.toW,
                    ),
                    itemBuilder: (context, index) {
                      var model = controller.caseBaseInfoList.value[index];
                      return AddTaskItem(model: model).withOnTap(() {
                        controller.lookCaseDetail(model);
                      });
                    },
                  );
                  ;
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      height: AppScreenUtil.navigationBarHeight,
      padding: EdgeInsets.only(
        top: AppScreenUtil.statusBarHeight,
        left: 16.toW,
        right: 16.toW,
      ),
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
            child: Obx(() {
              var homeController = getFindController<NewHomePageController>();
              return ClipOval(
                child: ImageUtils(
                  imageUrl:
                      homeController?.userModel.value?.avatar ??
                      Assets.home.defaultUserIcon.path,
                  placeholderImagePath: Assets.home.defaultUserIcon.path,
                ),
              );
            }),
          ).withOnTap(() {
            controller.openMyPageDrawer();
          }),
          Text(
            '案件',
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

  Widget _buildTabs() {
    final tabs = ['全部案件', '待更新', '进行中', '已归档'];
    return Obx(() {
      final current = controller.tabIndex.value;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 16.toW, right: 16.toW),
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
      ).withMarginOnly(top: 8.toW, bottom: 8.toW);
    });
  }

  Widget _setFloatingActionWidget() {
    return Container(
      width: 124.toW,
      height: 48.toW,
      margin: EdgeInsets.only(bottom: AppScreenUtil.bottomBarHeight + 90.toW),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.toW),
        color: AppColors.theme,
        boxShadow: [
          BoxShadow(
            color: Color(0x662563EB),
            blurRadius: 14,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageUtils(
            imageUrl: Assets.common.addDaibTaskIcon.path,
            width: 24.toW,
            height: 24.toW,
          ),
          Text(
            '创建案件',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.toSp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).withOnTap(() {
      controller.createCaseAction();
    });
  }
}
