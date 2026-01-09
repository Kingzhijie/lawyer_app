import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/string_extension.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/html_praser.dart';
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
            child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 24.toW)
                .withOnTap(() {
                  Get.back();
                }),
          ),
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
          children: controller.memberList.value
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
                          color: e == controller.selectMemberTag.value
                              ? Color(0xFFB95A2E)
                              : Color(0xFFE3A882),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        e.packageName ?? '',
                        style: TextStyle(
                          fontSize: 15.toSp,
                          fontWeight: e == controller.selectMemberTag.value
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: e == controller.selectMemberTag.value
                              ? Color(0xFF6D4520)
                              : Color(0xCC6D4520),
                        ),
                      ),
                    ).withOnTap(() {
                      controller.selectMemberTag.value = e;
                    }),
              )
              .toList(),
        ),
      ),
    );
  }

  ///设置对应的套餐图片
  Widget _setComboContentWidget() {
    return Obx(() {
      final detailContent = controller.selectMemberTag.value != null
          ? controller.selectMemberTag.value!.detailContent!.replaceAll(
              '\\n',
              '&nbsp',
            )
          : '';
      final nodes = RichTextParser.parse(detailContent);
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.toW, vertical: 20.toW),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: nodes.map((node) {
            switch (node.type) {
              case RichNodeType.text:
                return Text(
                  node.text ?? '',
                  style: TextStyle(
                    fontSize: 14.toSp,
                    color: AppColors.color_E6000000,
                    height: 1.6,
                  ),
                );
              case RichNodeType.image:
                return node.url != null && !node.url!.contains('file')
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Image.network(node.url!),
                      )
                    : SizedBox();
              default:
                return SizedBox();
            }
          }).toList(),
        ),
      );
    });
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
              Obx(
                () =>
                    controller.selectMemberTag.value != null &&
                        (controller.selectMemberTag.value!.promoPrice ?? 0) > 0
                    ? Positioned(
                        left: 0,
                        top: 0,
                        child: ImageUtils(
                          imageUrl: Assets.common.hyzhekIcon.path,
                          height: 21.toW,
                        ),
                      )
                    : SizedBox.shrink(),
              ),

              Obx(
                () =>
                    controller.selectMemberTag.value != null &&
                        (controller.selectMemberTag.value!.promoPrice ?? 0) > 0
                    ? Positioned(
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
                      )
                    : SizedBox.shrink(),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 左侧价格区域
                  Obx(() {
                    if (controller.selectMemberTag.value == null) {
                      return SizedBox();
                    }

                    final salesPrice =
                        controller.selectMemberTag.value!.salePrice ?? 0;
                    final promoPrice =
                        controller.selectMemberTag.value!.promoPrice ?? 0;
                    final originalPrice =
                        controller.selectMemberTag.value!.originalPrice ?? 0;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          ((promoPrice > 0 ? promoPrice : salesPrice) / 100)
                              .toString()
                              .toRMBPrice(),
                          style: TextStyle(
                            fontSize: 18.toSp,
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
                        if (promoPrice > 0)
                          Text(
                            '原价: ${(originalPrice / 100).toString().toRMBPrice()}',
                            style: TextStyle(
                              fontSize: 10.toSp,
                              color: Colors.white.withOpacity(0.7),
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.white.withOpacity(0.7),
                            ),
                          ),
                      ],
                    );
                  }),
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
                    controller.onCreatePayOrder();
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
