import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/bottom_sheet_utils.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

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
      color: AppColors.color_white,
      width: AppScreenUtil.screenWidth,
      height: AppScreenUtil.screenHeight,
      child: Stack(
        children: [
          ImageUtils(
            imageUrl: Assets.common.launchImg.path,
            width: AppScreenUtil.screenWidth,
            height: AppScreenUtil.screenHeight,
          ),
          if (widget.isFinishInit == false) ...[
            Container(
              width: AppScreenUtil.screenWidth,
              height: AppScreenUtil.screenHeight,
              color: Colors.black.withOpacity(0.4),
            ),
            _setContentWidget(),
          ],
        ],
      ),
    );
  }

  Widget _setContentWidget() {
    return Container(
      height: 539.toW,
      width: AppScreenUtil.screenWidth,
      margin: EdgeInsets.only(top: AppScreenUtil.screenHeight - 539.toW),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.toW)),
      ),
      padding: EdgeInsets.only(
        left: 24.toW,
        top: 28.toW,
        right: 24.toW,
        bottom: AppScreenUtil.bottomBarHeight + 12.toW,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '用户服务协议和隐私政策',
                style: TextStyle(
                  color: AppColors.color_E6000000,
                  fontSize: 17.toSp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Height(24.toW),
              Text('感谢您选择灵伴', style: TextStyle(color: AppColors.color_99000000, fontSize: 14.toSp, fontWeight: FontWeight.w500)),
              Height(11.toW),
              LightText(
                text: "我们依据相关法律法规制定了《灵伴用户服务协议》和《灵伴隐私政策》来帮助你了解：我们如何收集个人信息、如何使用及存储个人信息，以及你享有的相关权利。请你在开始我们的服务前，务必仔细阅读上述协议内容，尤其是加粗等标志性内容。我们将严格按照上述协议为你提供服务，保护你的信息安全。",
                textStyle:
                TextStyle(height: 1.6, fontSize: 14.toSp, color: AppColors.color_99000000),
                lightTexts: [
                  '《灵伴用户服务协议》',
                  '《灵伴隐私政策》'
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
            ],
          ),
          Row(
            children: [
              Container(
                height: 44.toW,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.toW),
                  border: Border.all(color: AppColors.theme, width: 0.8)
                ),
                alignment: Alignment.center,
                child: Text('不同意退出', style: TextStyle(color: AppColors.theme, fontSize: 15.toSp),),
              ).withOnTap((){
                exit(0);
              }).withExpanded(),
              Width(12.toW),
              Container(
                height: 44.toW,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.toW),
                  color: AppColors.theme
                ),
                alignment: Alignment.center,
                child: Text('同意', style: TextStyle(color: Colors.white, fontSize: 15.toSp),),
              ).withOnTap((){
                widget.agreeCallBack();
              }).withExpanded()
            ],
          )
        ],
      ),
    );
  }

  void _lookAgreementMethod(String text) {
    if (text == '《灵伴用户服务协议》') {
    } else if (text == '《灵伴隐私政策》') {
    }
  }
}
