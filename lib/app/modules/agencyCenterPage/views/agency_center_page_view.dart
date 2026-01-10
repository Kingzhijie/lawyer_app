import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/empty_content_widget.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../../../common/components/easy_refresher.dart';
import '../../newHomePage/views/widgets/task_card.dart';
import '../controllers/agency_center_page_controller.dart';

class AgencyCenterPageView extends StatelessWidget {
  final String? tag;
  const AgencyCenterPageView({super.key, this.tag});

  AgencyCenterPageController get controller =>
      Get.find<AgencyCenterPageController>(tag: tag);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: tag == null ? _setFloatingActionWidget() : null,
      body: Stack(
        children: [
          if (tag == null) ...[
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: ImageUtils(
                imageUrl: Assets.home.homeBg.path,
                width: AppScreenUtil.screenWidth,
              ),
            ),
            _setNavigationBar(),
          ],
          Positioned(
            left: 0,
            right: 0,
            top: tag == null ? AppScreenUtil.navigationBarHeight : 0,
            child: Column(children: [_setFilterWidget(), _buildTabs()]),
          ),
          _buildTaskCardsList(),
        ],
      ),
    );
  }

  Widget _setNavigationBar() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: Container(
        height: AppScreenUtil.navigationBarHeight,
        padding: EdgeInsets.only(
          top: AppScreenUtil.statusBarHeight,
          left: 14.toW,
          right: 14.toW,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 24.toW,
            ).withOnTap(() {
              Get.back();
            }),
            Text(
              '待办中心',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.toSp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 24.toW),
          ],
        ),
      ),
    );
  }

  Widget _setFilterWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.toW, horizontal: 16.toW),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _setFilterItemWidget(
              controller.casePartyIdModel.value?.name ?? '当事人',
              textColor:
                  !ObjectUtils.isEmptyString(
                    controller.casePartyIdModel.value?.name,
                  )
                  ? AppColors.color_E6000000
                  : AppColors.color_66000000,
            ).withOnTap(() {
              controller.chooseConcernedAction(0);
            }),
            _setFilterItemWidget(
              controller.taskTypeModel.value?.name ?? '任务类型',
              textColor:
                  !ObjectUtils.isEmptyString(
                    controller.taskTypeModel.value?.name,
                  )
                  ? AppColors.color_E6000000
                  : AppColors.color_66000000,
            ).withOnTap(() {
              controller.chooseConcernedAction(1);
            }),
            Container(
              width: 44.toW,
              height: 44.toW,
              alignment: Alignment.center,
              child: ImageUtils(
                imageUrl: Assets.home.searchIcon.path,
                width: 22.toW,
                height: 22.toW,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _setFilterItemWidget(
    String name, {
    Color textColor = AppColors.color_66000000,
  }) {
    return Container(
      width: 140.toW,
      height: 44.toW,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.toW),
        border: Border.all(color: AppColors.color_line, width: 0.4),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.toW),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(color: textColor, fontSize: 14.toSp),
          ).withExpanded(),
          ImageUtils(
            imageUrl: Assets.common.careDownQs.path,
            width: 16.toW,
            height: 16.toW,
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ['全部待办', '紧急任务', '今日到期', '已逾期'];
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
      ).withMarginOnly(top: 8.toW, bottom: 8.toW);
    });
  }

  Widget _buildTaskCardsList() {
    return MSEasyRefresher(
      controller: controller.easyRefreshController,
      onRefresh: () {
        controller.onRefresh();
      },
      onLoad: () {
        controller.onLoadMore();
      },
      childBuilder: (context, physics) {
        return Obx(
          () => controller.caseTaskList.value.isEmpty
              ? EmptyContentWidget()
              : ListView.builder(
                  physics: physics,
                  itemCount: controller.caseTaskList.length,
                  padding: EdgeInsets.only(top: 10.toW),
                  itemBuilder: (context, index) {
                    var model = controller.caseTaskList.value[index];
                    return TaskCard(
                          model: model,
                          clickItemType: (type) {
                            if (type == 1) {
                              //关联用户
                              controller.linkUserAlert();
                            }
                            if (type == 0) {
                              //备注
                              controller.addRemarkMethod(model);
                            }
                            if (type == 2) {
                              controller.addCalendar(model);
                            }
                          },
                        )
                        .withOnTap(() {
                          controller.lookContractDetailPage(model.caseId);
                        })
                        .withMarginOnly(bottom: 12.toW);
                  },
                ),
        );
      },
    ).withMarginOnly(
      top: 110.toW + (tag == null ? AppScreenUtil.navigationBarHeight : 0),
    );
  }

  Widget _setFloatingActionWidget() {
    return Container(
      width: 124.toW,
      height: 48.toW,
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
            '添加任务',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.toSp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ).withOnTap(() {
      controller.addTaskAction();
    });
  }
}
