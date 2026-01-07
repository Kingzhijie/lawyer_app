import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../controllers/vip_center_page_controller.dart';

class VipCenterPageView extends GetView<VipCenterPageController> {
  const VipCenterPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ImageUtils(
            imageUrl: Assets.common.openVipBg.path,
            width: AppScreenUtil.screenWidth,
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                _setLabelsWidget(),
                SingleChildScrollView(
                  child: _setComboContentWidget(),
                ).withExpanded(),
              ],
            ),
          ).withMarginOnly(
            top: AppScreenUtil.navigationBarHeight + 130.toW,
            bottom: 100.toW,
          ),
          _setBottomWidget(),
          Positioned(
            left: 15.toW,
              top: AppScreenUtil.statusBarHeight + 10.toW,
              child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24.toW).withOnTap((){
                Get.back();
              }))
        ],
      ),
    );
  }

  ///套餐tags
  Widget _setLabelsWidget() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15.toW),
      child: Obx(
        () => Row(
          children: controller.tags
              .map(
                (e) =>
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.toW,
                        vertical: 8.toW,
                      ),
                      margin: EdgeInsets.only(right: 6.toW),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.toW),
                        color: Color(0xFFFFF4E7),
                        border: Border.all(
                          color: e == controller.selectTag.value
                              ? Color(0xFFB95A2E)
                              : Color(0xFFE3A882),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        e,
                        style: TextStyle(
                          fontSize: 15.toSp,
                          fontWeight: e == controller.selectTag.value
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: e == controller.selectTag.value
                              ? Color(0xFF6D4520)
                              : Color(0xCC6D4520),
                        ),
                      ),
                    ).withOnTap(() {
                      controller.selectTag.value = e;
                    }),
              )
              .toList(),
        ),
      ),
    );
  }

  ///设置对应的套餐图片
  Widget _setComboContentWidget() {
    return ImageUtils(imageUrl: '', width: AppScreenUtil.screenWidth - 32.toW);
  }

  Widget _setBottomWidget() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.all(24.toW),
        margin: EdgeInsets.only(bottom: AppScreenUtil.bottomBarHeight),
        child: Container(
          height: 60.toW,
          child: Stack(
            children: [
              // 底部背景图
              Positioned(
                right: 0,
                top: 8.toW,
                child: ImageUtils(
                  imageUrl: Assets.common.lizfBg.path,
                  height: 52.toW,
                  fit: BoxFit.fill,
                ),
              ),
              // 底部背景图
              Positioned(
                left: 0,
                top: 8.toW,
                child: ImageUtils(
                  imageUrl: Assets.common.vipPriceBg.path,
                  height: 52.toW,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: ImageUtils(
                  imageUrl: Assets.common.hyzhekIcon.path,
                  height: 21.toW,
                ),
              ),
              Positioned(
                left: 10.toW,
                top: 3.toW,
                child: Text(
                  '限时折扣价',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.toSp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 左侧价格区域
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '¥198',
                        style: TextStyle(
                          fontSize: 20.toSp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '/年',
                        style: TextStyle(
                          fontSize: 12.toSp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10.toW),
                      Text(
                        '原价: ¥600',
                        style: TextStyle(
                          fontSize: 12.toSp,
                          color: Colors.white.withOpacity(0.7),
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  // 右侧确认支付按钮
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 5.toW, right: 13.toW),
                    child: Text(
                      '确认并支付',
                      style: TextStyle(
                        fontSize: 16.toSp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6D4520),
                      ),
                    ),
                  ).withOnTap(() {
                    // 点击支付
                  }),
                ],
              ).withPaddingOnly(left: 12.toW, top: 5.toW),
            ],
          ),
        ),
      ),
    );
  }
}
