import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../controllers/login_page_controller.dart';

class LoginPageView extends GetView<LoginPageController> {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(30.toW, 24.toW, 30.toW, 40.toW),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppScreenUtil.bottomBarHeight + 40.toW),
                  _buildLogoTitle(),
                  SizedBox(height: 30.toW),
                  _buildPhoneField(),
                  SizedBox(height: 12.toW),
                  Text(
                    '未注册过的手机号将自动注册',
                    style: TextStyle(
                      fontSize: 12.toSp,
                      color: AppColors.color_66000000,
                    ),
                  ),
                  SizedBox(height: 32.toW),
                  _buildSendCodeButton(),
                  SizedBox(height: 20.toW),
                  _buildProtocol(),
                ],
              ),
            ),
          ),
        ],
      ),
    ).unfocusWhenTap();
  }

  Widget _buildTopActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.toW, vertical: 10.toW),
          decoration: BoxDecoration(
            color: AppColors.color_white,
            borderRadius: BorderRadius.circular(20.toW),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageUtils(
                imageUrl: Assets.common.appLogo.path,
                width: 18.toW,
                height: 18.toW,
              ),
              SizedBox(width: 12.toW),
              Container(
                width: 6.toW,
                height: 6.toW,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.color_66000000,
                ),
              ),
              SizedBox(width: 6.toW),
              Container(
                width: 6.toW,
                height: 6.toW,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.color_66000000,
                ),
              ),
              SizedBox(width: 6.toW),
              Container(
                width: 6.toW,
                height: 6.toW,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.color_66000000,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageUtils(
          imageUrl: Assets.common.lingbanIcon.path,
          height: 32.toW,
        ),
        SizedBox(height: 12.toW),
        Text(
          '手机号验证码登录',
          style: TextStyle(
            fontSize: 24.toSp,
            fontWeight: FontWeight.w600,
            color: AppColors.color_E6000000,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.toW),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.toW),
        border: Border.all(color: AppColors.color_FFC5C5C5, width: 0.6)
      ),
      height: 52.toW,
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller.phoneController,
        keyboardType: TextInputType.phone,
        maxLength: 11,
        cursorColor: AppColors.theme,
        style: TextStyle(
          fontSize: 16.toSp,
          color: AppColors.color_E6000000,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          hintText: '请输入手机号',
          hintStyle: TextStyle(
            fontSize: 16.toSp,
            color: AppColors.color_FFC5C5C5,
          ),
        ),
      ),
    );
  }

  Widget _buildSendCodeButton() {
    return Obx(() {
      final loading = controller.isSending.value;
      return GestureDetector(
        onTap: loading ? null : controller.sendCode,
        child: Container(
          width: double.infinity,
          height: 52.toW,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF0060FF),
                Color(0xFF10B2F9),
              ],
            ),
            borderRadius: BorderRadius.circular(12.toW),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0A7DFF).withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: loading
              ? SizedBox(
                  width: 20.toW,
                  height: 20.toW,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.color_white,
                    ),
                  ),
                )
              : Text(
                  '获取短信验证码',
                  style: TextStyle(
                    fontSize: 16.toSp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.color_white,
                  ),
                ),
        ),
      );
    });
  }

  Widget _buildProtocol() {
    return Obx(() {
      final agreed = controller.agreeProtocol.value;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: agreed,
            activeColor: AppColors.theme,
            onChanged: controller.toggleAgree,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          Expanded(
            child: Wrap(
              spacing: 4.toW,
              runSpacing: 4.toW,
              children: [
                Text(
                  '我已阅读并同意',
                  style: TextStyle(
                    fontSize: 12.toSp,
                    color: AppColors.color_99000000,
                  ),
                ),
                _protocolLink('《用户协议》'),
                Text(
                  '与',
                  style: TextStyle(
                    fontSize: 12.toSp,
                    color: AppColors.color_99000000,
                  ),
                ),
                _protocolLink('《隐私政策》'),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _protocolLink(String text) {
    return GestureDetector(
      onTap: controller.lookProtocol,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.toSp,
          color: AppColors.theme,
        ),
      ),
    );
  }
}
