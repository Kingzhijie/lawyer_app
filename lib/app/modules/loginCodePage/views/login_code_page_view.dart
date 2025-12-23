import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../controllers/login_code_page_controller.dart';

class LoginCodePageView extends GetView<LoginCodePageController> {
  const LoginCodePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: ImageUtils(
              imageUrl: Assets.home.homeBg.path,
              width: AppScreenUtil.screenWidth,
            ),
          ),
          Obx(
                () => SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                30.toW,
                16.toW,
                30.toW,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.toW + AppScreenUtil.navigationBarHeight),
                  _buildTitle(controller.displayPhone),
                  SizedBox(height: 28.toW),
                  _buildCodeInputs(),
                  SizedBox(height: 22.toW),
                  _buildResend(controller.countdown.value),
                ],
              ),
            ),
          ),
          Positioned(
            top: AppScreenUtil.statusBarHeight,
            child: Container(
              width: 50.toW,
              padding: EdgeInsets.only(left: 10.toW),
              height: AppScreenUtil.navigationBarHeight - AppScreenUtil.statusBarHeight,
              alignment: Alignment.center,
              child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 22.toW),
            ).withOnTap((){
              Get.back();
            }),
          ),
        ],
      ),
    ).unfocusWhenTap();
  }

  Widget _buildTitle(String phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '请输入验证码',
          style: TextStyle(
            fontSize: 24.toSp,
            fontWeight: FontWeight.w600,
            color: AppColors.color_E6000000,
          ),
        ),
        SizedBox(height: 4.toW),
        Text(
          '验证码已通过短信发送至 $phone',
          style: TextStyle(
            fontSize: 12.toSp,
            color: AppColors.color_66000000,
          ),
        ),
      ],
    );
  }

  Widget _buildCodeInputs() {
    final boxes = List.generate(4, (i) => i);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(Get.context!).requestFocus(controller.codeFocusNode);
      },
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: boxes
                .map(
                  (i) => Obx(
                    () {
                      final text = controller.code.value;
                      final char = (i < text.length) ? text[i] : '';
                      final bool isCurrent =
                          (i == text.length) && text.length < boxes.length;
                      return Container(
                        width: 58.toW,
                        height: 58.toW,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.color_white,
                          borderRadius: BorderRadius.circular(8.toW),
                          border: Border.all(
                            color: AppColors.color_FFC5C5C5,
                            width: 0.8,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (char.isNotEmpty)
                              Text(
                                char,
                                style: TextStyle(
                                  fontSize: 23.toSp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.color_E6000000,
                                ),
                              ),
                            if (char.isEmpty && isCurrent)
                              Obx(() => Opacity(
                                    opacity: controller.cursorVisible.value
                                        ? 1
                                        : 0,
                                    child: Container(
                                      width: 2.toW,
                                      height: 26.toW,
                                      color: AppColors.color_66000000,
                                    ),
                                  )),
                          ],
                        ),
                      );
                    },
                  ),
                )
                .toList(),
          ),
          // 隐藏实际输入框，负责接收键盘输入
          Positioned.fill(
            child: Opacity(
              opacity: 0.0,
              child: TextField(
                focusNode: controller.codeFocusNode,
                controller: controller.codeController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResend(int countdown) {
    final bool canResend = countdown <= 0;
    final text = canResend ? '重新获取' : '重新获取  (${countdown}s)';
    final color = canResend ? AppColors.theme : AppColors.color_FFC5C5C5;
    return GestureDetector(
      onTap: canResend ? controller.resendCode : null,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.toSp,
          color: color,
        ),
      ),
    );
  }
}
