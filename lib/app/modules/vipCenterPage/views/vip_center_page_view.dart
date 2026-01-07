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
          height: 52.toW,
          child: Stack(
            children: [
              // 底部背景图
              Positioned.fill(
                child: ImageUtils(
                  imageUrl: Assets.common.lizfBg.path,
                  width: AppScreenUtil.screenWidth,
                  fit: BoxFit.fill,
                ),
              ),
              Row(
                children: [
                  // 左侧价格区域
                  Expanded(
                    child: Stack(
                      children: [
                        // 价格背景图
                        Positioned.fill(
                          child: ImageUtils(
                            imageUrl: Assets.common.vipPriceBg.path,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.toW),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 限时折扣价标签
                              ImageUtils(
                                imageUrl: Assets.common.hyzhekIcon.path,
                                height: 18.toW,
                              ),
                              SizedBox(height: 4.toW),
                              // 价格行
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '¥198',
                                    style: TextStyle(
                                      fontSize: 32.toSp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '/年',
                                    style: TextStyle(
                                      fontSize: 14.toSp,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 右侧确认支付按钮
                  Container(
                    width: 140.toW,
                    alignment: Alignment.center,
                    child: Text(
                      '确认并支付',
                      style: TextStyle(
                        fontSize: 18.toSp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6D4520),
                      ),
                    ),
                  ).withOnTap(() {
                    // 点击支付
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
