import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/common_app_bar.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../controllers/about_us_page_controller.dart';

class AboutUsPageView extends GetView<AboutUsPageController> {
  const AboutUsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color_FFF3F3F3,
      appBar: CommonAppBar(
        title: '关于我们',
        backgroundColor: AppColors.color_FFF3F3F3,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 40.toW),
                    _buildAppInfo(),
                    SizedBox(height: 40.toW),
                    _buildMenuItems(),
                  ],
                ),
              ),
            ),
            _buildCopyright(),
          ],
        ),
      ),
    );
  }

  /// App 信息区域
  Widget _buildAppInfo() {
    return Column(
      children: [
        ImageUtils(
          imageUrl: Assets.common.lingbanIcon.path,
          width: 110.toW,
        ),
        SizedBox(height: 16.toW),
        Text(
          '当前版本: 1.0',
          style: TextStyle(
            fontSize: 14.toSp,
            color: AppColors.color_66000000,
          ),
        ),
      ],
    );
  }

  /// 菜单项列表
  Widget _buildMenuItems() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.toW),
      decoration: BoxDecoration(
        color: AppColors.color_white,
        borderRadius: BorderRadius.circular(12.toW),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            title: '用户服务协议',
            onTap: () {
              controller.openUserServiceAgreement();
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            title: '隐私政策',
            onTap: () {
              controller.openPrivacyPolicy();
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            title: '关于我们',
            onTap: () {
              // 当前页面，可以不做处理或显示详细信息
            },
          ),
        ],
      ),
    );
  }

  /// 单个菜单项
  Widget _buildMenuItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.toW, vertical: 16.toW),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.toSp,
              color: AppColors.color_E6000000,
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16.toW,
            color: AppColors.color_FFC5C5C5,
          ),
        ],
      ),
    ).withOnTap(onTap);
  }

  /// 分割线
  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.only(left: 16.toW),
      height: 0.5,
      color: AppColors.color_line,
    );
  }

  /// 版权信息
  Widget _buildCopyright() {
    return Container(
      padding: EdgeInsets.only(bottom: 20.toW),
      child: Text(
        '法洛(杭州)信息科技咨询有限公司',
        style: TextStyle(
          fontSize: 12.toSp,
          color: AppColors.color_FFC5C5C5,
        ),
      ),
    );
  }
}
