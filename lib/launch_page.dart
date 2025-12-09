import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/common/components/light_text.dart';
import 'app/common/constants/app_colors.dart';
import 'app/common/extension/widget_extension.dart';
import 'app/utils/image_utils.dart';
import 'app/utils/screen_utils.dart';

//APP的启动页
class LaunchPage extends StatefulWidget {
  final Function() agreeCallBack;
  final bool? isFinishInit;

  const LaunchPage({super.key, required this.agreeCallBack, this.isFinishInit});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        color: AppColors.color_FFF5F5F5,
        width: AppScreenUtil.screenWidth,
        height: AppScreenUtil.screenHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ImageUtils(
                imageUrl: '',
                width: AppScreenUtil.screenWidth,
                height: AppScreenUtil.screenHeight),
            if (widget.isFinishInit == false) _setContentWidget()
          ],
        ));
  }

  Widget _setContentWidget() {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.color_FF1F1F1F,
          borderRadius: BorderRadius.circular(12.toW)),
      width: 295.toW,
      padding: EdgeInsets.only(
          left: 24.toW, right: 24.toW, bottom: 12.toW, top: 12.toW),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '个人信息保护提示',
            style: TextStyle(
                fontSize: 18.toSp,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
          Height(12.toW),
          LightText(
            text: "欢迎使用腰动力！\n我们将通过《用户协议》和《隐私政策》帮助您了解我们的服务，我们如何处理您的个人信息，以及您享有的权利。我们严格遵守相关法律法规，并采取各种安全措施保护您的个人信息。\n点击同意按钮，即表示您知悉并同意上述协议及以下条款。",
            textStyle:
                TextStyle(height: 1.6, fontSize: 14.toSp, color: Colors.white),
            lightTexts: [
              '《用户协议》',
              '《隐私政策》'
            ],
            lightStyle: TextStyle(
                height: 1.6,
                fontSize: 14.toSp,
                color: AppColors.theme,
                fontWeight: FontWeight.w600),
            onTapLightText: (text) {
              _lookAgreementMethod(text);
            },
          ),
          Height(32.toW),
          Container(
            decoration: BoxDecoration(
                color: AppColors.theme,
                borderRadius: BorderRadius.circular(12.toW)),
            alignment: Alignment.center,
            height: 44.toW,
            child: Text(
              '同意',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.toSp,
                  fontWeight: FontWeight.w600),
            ),
          ).withOnTap(() {
            widget.agreeCallBack();
          }),
          Height(12.toW),
          Text(
            '不同意',
            style:
                TextStyle(color: AppColors.color_B3FFFFFF, fontSize: 14.toSp),
          ).withOnTap(() {
            exit(0);
          })
        ],
      ),
    );
  }

  void _lookAgreementMethod(String text) {
    // if (text == '《${S.of(context).userAgreement}》') {
    //   Get.toNamed(Routes.WEB_PAGE, arguments: AppAgreement.userAgreement);
    // } else if (text == '《${S.of(context).privacyPolicy}》') {
    //   Get.toNamed(Routes.WEB_PAGE,
    //       arguments: AppAgreement.privacyServiceAgreement);
    // }
  }

}
