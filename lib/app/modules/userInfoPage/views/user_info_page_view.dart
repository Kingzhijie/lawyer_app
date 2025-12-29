import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/common_app_bar.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/myPage/models/user_model.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../../../utils/object_utils.dart';
import '../../newHomePage/controllers/new_home_page_controller.dart';
import '../controllers/user_info_page_controller.dart';

class UserInfoPageView extends GetView<UserInfoPageController> {
  const UserInfoPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color_FFF3F3F3,
      appBar: CommonAppBar(
        title: '个人信息',
        backgroundColor: AppColors.color_FFF3F3F3,
      ),
      body: SafeArea(
        child: Obx((){
          var userModel = controller.userModel.value;
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12.toW),
                _buildUserProfileCard(userModel),
                SizedBox(height: 12.toW),
                _buildPhoneNumberCard(userModel),
                SizedBox(height: 12.toW),
                _buildClearCacheCard(),
              ],
            ).withMarginOnly(left: 16.toW, right: 16.toW, top: 12.toW),
          );
        }),
      ),
    );
  }

  /// 用户资料卡片
  Widget _buildUserProfileCard(UserModel? userModel) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color_white,
        borderRadius: BorderRadius.circular(12.toW),
      ),
      child: Column(
        children: [
          _buildProfileRow(
            label: '头像',
            child: Obx(()=>ImageUtils(
              imageUrl: controller.userIcon.value ?? '',
              width: 48.toW,
              height: 48.toW,
              circularRadius: 24.toW,
              placeholderImagePath: Assets.home.defaultUserIcon.path,
            )),
            onTap: () {
              controller.changeAvatar();
            },
          ),
          _buildProfileRow(
            label: '昵称',
            child: Obx(()=>Row(
              children: [
                Text(
                  controller.nickName.value ?? '',
                  style: TextStyle(
                    fontSize: 16.toSp,
                    color: AppColors.color_E6000000,
                  ),
                ),
                SizedBox(width: 8.toW),
                Icon(
                  Icons.edit,
                  size: 16.toW,
                  color: AppColors.color_FFC5C5C5,
                ),
              ],
            )),
            onTap: () {
              controller.editNickname();
            },
          ),
        ],
      ),
    );
  }

  /// 手机号码卡片
  Widget _buildPhoneNumberCard(UserModel? userModel) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color_white,
        borderRadius: BorderRadius.circular(12.toW),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.toW, vertical: 16.toW),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '手机号码',
            style: TextStyle(
              fontSize: 16.toSp,
              color: AppColors.color_E6000000,
            ),
          ),
          Text(
            '+86 ${userModel?.mobile ?? ''}',
            style: TextStyle(
              fontSize: 16.toSp,
              color: AppColors.color_E6000000,
            ),
          ),
        ],
      ),
    );
  }

  /// 清理缓存卡片
  Widget _buildClearCacheCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.color_white,
        borderRadius: BorderRadius.circular(12.toW),
      ),
      padding: EdgeInsets.all(16.toW),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '清理本地缓存',
                style: TextStyle(
                  fontSize: 16.toSp,
                  color: AppColors.color_E6000000,
                ),
              ),
              Text(
                '清理',
                style: TextStyle(
                  fontSize: 16.toSp,
                  color: AppColors.theme,
                ),
              )
            ],
          ),
          SizedBox(height: 8.toW),
          Text(
            '缓存为本机临时缓存文件,云端不受影响',
            style: TextStyle(
              fontSize: 12.toSp,
              color: AppColors.color_FFC5C5C5,
            ),
          ),
        ],
      ),
    ).withOnTap((){
      controller.clearCache();
    });
  }

  /// 资料行
  Widget _buildProfileRow({
    required String label,
    required Widget child,
    VoidCallback? onTap,
  }) {
    final widget = Container(
      padding: EdgeInsets.symmetric(horizontal: 16.toW, vertical: 16.toW),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.toSp,
              color: AppColors.color_E6000000,
            ),
          ),
          child,
        ],
      ),
    );
    return onTap != null ? widget.withOnTap(onTap) : widget;
  }

}
