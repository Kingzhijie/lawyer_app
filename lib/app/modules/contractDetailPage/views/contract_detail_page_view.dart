import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import '../../../../gen/assets.gen.dart';
import '../../../utils/image_utils.dart';
import '../../../utils/screen_utils.dart';
import '../controllers/contract_detail_page_controller.dart';
import 'widget/case_base_info_widget.dart';
import 'widget/case_progress_widget.dart';
import 'widget/case_related_certificate_widget.dart';
import 'widget/case_save_detail_widget.dart';
import 'widget/case_task_list_widget.dart';

enum CaseActionType {
  caseArchiving('归档'),
  caseAppeal('上诉'),
  caseDelete('删除');

  const CaseActionType(this.title);

  final String title;
}

class ContractDetailPageView extends GetView<ContractDetailPageController> {
  const ContractDetailPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
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
          // 内容
          Column(
            children: [
              _buildAppBar(),
              Obx(
                () => controller.currentCaseProcedure.value > 1
                    ? _buildTrialTabs()
                    : SizedBox.shrink(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: AppScreenUtil.bottomBarHeight,
                  ),
                  child: Obx(
                    () => controller.caseDetail.value == null
                        ? CircularProgressIndicator()
                        : Column(
                            children: [
                              CaseBaseInfoWidget(
                                caseDetail: controller.caseDetail.value!,
                                onCaseEditTap: () =>
                                    controller.onCaseDetail(tabIndex: 0),
                              ),
                              Height(16.toW),
                              CaseTaskListWidget(
                                tasks:
                                    controller.caseDetail.value!.taskList ?? [],
                                onAddTap: controller.addTask,
                                onCheckTasksTap: () =>
                                    controller.onCaseDetail(tabIndex: 3),
                              ),

                              if (controller.caseDetail.value!.presAssetList !=
                                      null &&
                                  controller
                                      .caseDetail
                                      .value!
                                      .presAssetList!
                                      .isNotEmpty) ...[
                                Height(16.toW),
                                CaseSaveDetailWidget(
                                  presAssetList:
                                      controller
                                          .caseDetail
                                          .value!
                                          .presAssetList ??
                                      [],
                                  onCheckAssetsTap: () =>
                                      controller.onCaseDetail(tabIndex: 1),
                                ),
                              ],
                              Height(16.toW),
                              CaseRelatedCertificateWidget(
                                docList:
                                    controller.caseDetail.value!.docList ?? [],
                                onCheckDocsTap: () =>
                                    controller.onCaseDetail(tabIndex: 2),
                              ),
                              if (controller.caseTimelineList.isNotEmpty) ...[
                                Height(16.toW),
                                CaseProgressWidget(
                                  progressList: controller.caseTimelineList,
                                ),
                              ],

                              SizedBox(height: 80.toW), // 底部栏高度 + 安全距离
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
          // 底部栏
          Obx(
            () => controller.caseDetail.value == null
                ? SizedBox.shrink()
                : Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _buildBottomBar(),
                  ),
          ),
        ],
      ),
    ).setStatusBarStyle();
  }

  // 顶部导航栏
  Widget _buildAppBar() {
    return Container(
      height: AppScreenUtil.navigationBarHeight,
      padding: EdgeInsets.only(
        left: 16.toW,
        right: 16.toW,
        top: AppScreenUtil.statusBarHeight,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              alignment: Alignment.centerLeft,
              width: 30.toW,
              child: Icon(
                Icons.arrow_back_ios,
                size: 20.toW,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => Text(
                controller.caseDetail.value?.caseBase?.caseName ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.toSp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz, color: Colors.black, size: 22.toW),
            offset: Offset(0, 40.toW),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.toW),
            ),
            color: Colors.white,
            elevation: 8,
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context) => [
              _buildPopupMenuItem(
                icon: Assets.my.guidangIcon.path,
                label: CaseActionType.caseArchiving,
              ),
              _buildPopupMenuItem(
                icon: Assets.my.shangsuIcon.path,
                label: CaseActionType.caseAppeal,
              ),
              _buildPopupMenuItem(
                icon: Assets.my.deleteHtIcon.path,
                label: CaseActionType.caseDelete,
              ),
            ],
            onSelected: (String value) {
              controller.handleMenuAction(value);
            },
          ),
        ],
      ),
    );
  }

  // 审级选项卡
  Widget _buildTrialTabs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.toW),
      padding: EdgeInsets.symmetric(vertical: 12.toW),
      height: 60.toW,
      child: Row(
        children: [
          _buildTrialTab('一审', 0),
          _buildTrialTab('二审', 1),
          _buildTrialTab('再审', 2),
        ],
      ),
    );
  }

  Widget _buildTrialTab(String title, int index) {
    return Obx(() {
      final isSelected = controller.trialIndex.value == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => controller.switchTrial(index),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.theme : AppColors.color_FFF3F3F3,
              borderRadius: BorderRadius.circular(8.toW),
            ),
            margin: EdgeInsets.symmetric(horizontal: 6.toW),
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13.toSp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.white : AppColors.color_99000000,
              ),
            ),
          ),
        ),
      );
    });
  }

  // 底部栏
  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 16.toW,
        right: 16.toW,
        top: 12.toW,
        bottom: AppScreenUtil.bottomBarHeight + 12.toW,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 团队成员头像
          _buildTeamAvatars(),
          Spacer(),
          // 上传文件按钮
          GestureDetector(
            onTap: controller.uploadFile,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 44.toW,
              width: 95.toW,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.theme, width: 1),
                borderRadius: BorderRadius.circular(8.toW),
              ),
              alignment: Alignment.center,
              child: Text(
                '上传文件',
                style: TextStyle(
                  fontSize: 15.toSp,
                  color: AppColors.theme,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.toW),
          // 创建任务按钮
          GestureDetector(
            onTap: controller.addTask,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 44.toW,
              width: 95.toW,
              decoration: BoxDecoration(
                color: AppColors.theme,
                borderRadius: BorderRadius.circular(8.toW),
              ),
              alignment: Alignment.center,
              child: Text(
                '创建任务',
                style: TextStyle(
                  fontSize: 15.toSp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 团队成员头像
  Widget _buildTeamAvatars() {
    final relateUsers = controller.caseDetail.value?.relateUsers ?? [];
    return SizedBox(
      width: 100.toW,
      height: 44.toW,
      child: Stack(
        children: [
          ...relateUsers.take(3).toList().asMap().entries.map((item) {
            return Stack(
              children: [
                ImageUtils(
                  imageUrl: item.value.avatar,
                  width: 36.toW,
                  height: 36.toW,
                  fit: BoxFit.cover,
                  circularRadius: 18.toW,
                  placeholderImagePath: Assets.home.defaultUserIcon.path,
                ),
                if (ObjectUtils.boolValue(item.value.isSponsor))
                  Positioned(
                    left: 3.toW,
                    right: 3.toW,
                    bottom: 0,
                    child: Container(
                      height: 10.toW,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.toW),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFFFE9CD), Color(0xFFE0AF7D)],
                        ),
                      ),
                      child: Text(
                        '发起人',
                        style: TextStyle(
                          color: Color(0xFF603619),
                          fontSize: 6.toSp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
          // 添加按钮
          Positioned(
            left: relateUsers.length * 24.toW,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: controller.onLinkUser,
              child: Container(
                width: 36.toW,
                height: 36.toW,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.color_line, width: 0.5),
                ),
                child: Icon(
                  Icons.add,
                  size: 20.toW,
                  color: AppColors.color_99000000,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 构建弹出菜单项
  PopupMenuItem<String> _buildPopupMenuItem({
    required String icon,
    required CaseActionType label,
  }) {
    return PopupMenuItem<String>(
      value: label.title,
      height: 48.toW,
      child: Row(
        children: [
          ImageUtils(imageUrl: icon, width: 20.toW),
          SizedBox(width: 12.toW),
          Text(
            label.title,
            style: TextStyle(
              fontSize: 15.toSp,
              color: AppColors.color_E6000000,
            ),
          ),
        ],
      ),
    );
  }
}
