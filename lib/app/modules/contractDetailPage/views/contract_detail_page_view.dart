import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import '../../../../gen/assets.gen.dart';
import '../../../utils/image_utils.dart';
import '../../../utils/screen_utils.dart';
import '../../chatPage/views/widgets/no_find_case_widget.dart';
import '../controllers/contract_detail_page_controller.dart';
import 'widget/case_base_info_widget.dart';
import 'widget/case_progress_widget.dart';
import 'widget/case_related_certificate_widget.dart';
import 'widget/case_save_detail_widget.dart';
import 'widget/case_task_list_widget.dart';

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
              _buildTrialTabs(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: AppScreenUtil.bottomBarHeight),
                  child: Column(
                    children: [
                      const CaseBaseInfoWidget(),
                      Height(16.toW),
                      const CaseTaskListWidget(),
                      Height(16.toW),
                      const CaseSaveDetailWidget(),
                      Height(16.toW),
                      const CaseRelatedCertificateWidget(),
                      Height(16.toW),
                      const CaseProgressWidget(),
                      SizedBox(height: 80.toW), // 底部栏高度 + 安全距离
                    ],
                  ),
                ),
              ),
            ],
          ),
          // 底部栏
          Positioned(left: 0, right: 0, bottom: 0, child: _buildBottomBar()),
        ],
      ),
    );
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
            child: Icon(
              Icons.arrow_back_ios,
              size: 20.toW,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              '张三诉讼李四合同纠纷案',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.toSp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 20.toW),
        ],
      ),
    );
  }

  // 审级选项卡
  Widget _buildTrialTabs() {
    return Obx(() {
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
    });
  }

  Widget _buildTrialTab(String title, int index) {
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
            onTap: () {},
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
            onTap: () {},
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
    return SizedBox(
      width: 100.toW,
      height: 44.toW,
      child: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          // 第一个头像
          Positioned(
            left: 0,
            child: Container(
              width: 36.toW,
              height: 36.toW,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  '张',
                  style: TextStyle(
                    fontSize: 14.toSp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          // 第二个头像
          Positioned(
            left: 24.toW,
            child: Container(
              width: 36.toW,
              height: 36.toW,
              decoration: BoxDecoration(
                color: const Color(0xFFFF5252),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  '李',
                  style: TextStyle(
                    fontSize: 14.toSp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          // 第三个头像
          Positioned(
            left: 48.toW,
            child: Container(
              width: 36.toW,
              height: 36.toW,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Text(
                  '王',
                  style: TextStyle(
                    fontSize: 14.toSp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          // 添加按钮
          Positioned(
            left: 72.toW,
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
        ],
      ),
    );
  }
}
