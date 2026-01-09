import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

class VipSuccessPop extends StatelessWidget {
  final VoidCallback onConfirmTap;
  const VipSuccessPop({super.key, required this.onConfirmTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.toW),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ImageUtils(
                imageUrl: Assets.common.vipBackIcon.path,
                width: 301.toW,
                height: 282.toW,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '您已成功开通',
                    style: TextStyle(
                      fontSize: 16.toSp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF402E20),
                    ),
                  ),
                  ImageUtils(
                    imageUrl: Assets.common.vipIcon.path,
                    width: 115.toW,
                    height: 96.toW,
                  ),
                  Text(
                    '灵伴超级会员',
                    style: TextStyle(
                      fontSize: 16.toSp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF402E20),
                    ),
                  ),
                  SizedBox(height: 10.toW),
                  Text(
                    '有效期至：2026-12-31',
                    style: TextStyle(
                      fontSize: 12.toSp,
                      color: Color(0xFF402E20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 35.toW),
                    width: 228.toW,
                    height: 42.toW,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundBuilder: (context, states, child) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFC48A50), Color(0xFF814809)],
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '确认并开始享受会员',
                              style: TextStyle(
                                fontSize: 15.toSp,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.toW),
                        ),
                      ),
                      child: SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 28.toW),
          ImageUtils(
            imageUrl: Assets.common.closeArrowIcon.path,
            width: 32.toW,
            height: 32.toW,
          ).withOnTap(() {
            Get.back();
          }),
        ],
      ),
    );
  }
}
