import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/newHomePage/controllers/new_home_page_controller.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../controllers/my_page_controller.dart';

class MyPageView extends GetView<MyPageController> {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.color_white,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUserInfo(),
                    SizedBox(height: 24.toW),
                    _buildProMemberCard(),
                    SizedBox(height: 24.toW),
                    _buildMenuItems(),
                  ],
                ).withMarginOnly(left: 16.toW, right: 16.toW, top: 20.toW),
              ),
            ),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  /// 用户信息区域
  Widget _buildUserInfo() {
    return Obx((){
      var homeController = getFindController<NewHomePageController>();
      var userModel = homeController?.userModel.value;
      return Row(
        children: [
          ImageUtils(
            imageUrl: userModel?.avatar,
            width: 48.toW,
            height: 48.toW,
            circularRadius: 24.toW,
            placeholderImagePath: Assets.home.defaultUserIcon.path,
          ),
          SizedBox(width: 12.toW),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel?.nickname ?? '',
                  style: TextStyle(
                    fontSize: 16.toSp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color_E6000000,
                  ),
                ),
                SizedBox(height: 4.toW),
                Text(
                  userModel?.mobile ?? '',
                  style: TextStyle(
                    fontSize: 13.toSp,
                    color: AppColors.color_66000000,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 22.toW,
            height: 22.toW,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11.toW),
                color: AppColors.color_FFF3F3F3
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_forward_ios,
              size: 12.toW,
              color: AppColors.color_FFC5C5C5,
            ),
          ),
        ],
      ).withOnTap(() {
        controller.pushUserInfoPage();
      });
    });
  }

  /// PRO 会员卡片
  Widget _buildProMemberCard() {
    return ImageUtils(imageUrl: Assets.my.vipCardBg.path).withOnTap((){
      controller.openVipCenterPage();
    });
  }

  /// 菜单项
  Widget _buildMenuItems() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Assets.my.inviteFriend.path,
          title: '邀请好友',
          onTap: () {
            controller.pushInviteFriendPage();
          },
        ),
        SizedBox(height: 6.toW),
        _buildMenuItem(
          icon: Assets.my.aboutUsIcon.path,
          title: '关于我们',
          onTap: () {
            controller.pushAboutUsPage();
          },
        ),
      ],
    );
  }

  /// 单个菜单项
  Widget _buildMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.toW),
      child: Row(
        children: [
          ImageUtils(
            imageUrl: icon,
            width: 24.toW,
            height: 24.toW,
          ),
          SizedBox(width: 12.toW),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.toSp,
                color: AppColors.color_E6000000,
              ),
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

  /// 退出登录按钮
  Widget _buildLogoutButton() {
    return Container(
      margin: EdgeInsets.only(
        left: 16.toW,
        right: 16.toW,
        bottom: 20.toW,
      ),
      child: Container(
        height: 44.toW,
        decoration: BoxDecoration(
          color: AppColors.color_FFF5F7FA,
          borderRadius: BorderRadius.circular(12.toW),
        ),
        alignment: Alignment.center,
        child: Text(
          '退出登录',
          style: TextStyle(
            fontSize: 16.toSp,
            color: AppColors.color_E6000000,
          ),
        ),
      ).withOnTap(() {
        // TODO: 退出登录
        controller.logout();
      }),
    );
  }
}
