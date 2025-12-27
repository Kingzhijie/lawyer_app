import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/components/image_text_button.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../../../../utils/screen_utils.dart';

class HomeVoiceWidget extends StatelessWidget {
  const HomeVoiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xAD000000),
      width: AppScreenUtil.screenWidth,
      height: AppScreenUtil.screenHeight,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 24.toW),
            margin: EdgeInsets.only(bottom: AppScreenUtil.bottomBarHeight + 90.toW),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageUtils(
                      imageUrl: Assets.home.zhengzaiTingIcon.path,
                      width: 20.toW,
                    ),
                    Width(5.toW),
                    Text(
                      '请说，我在听',
                      style: TextStyle(
                        color: Color(0xFF33FCFF),
                        fontSize: 18.toSp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Height(24.toW),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 240.toW,
                    maxHeight: 450.toW
                  ),
                  child: Text(
                    '请查询12月的缴纳诉讼费相关案件。',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.toSp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            left: 16.toW,
            right: 16.toW,
            bottom: AppScreenUtil.bottomBarHeight + 10.toW,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.theme,
                borderRadius: BorderRadius.circular(12.toW),
              ),
              alignment: Alignment.center,
              height: 52.toW,
              child: Text(
                '按住说话',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.toSp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
