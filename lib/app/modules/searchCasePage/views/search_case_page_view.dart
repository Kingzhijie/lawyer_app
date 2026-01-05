import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../controllers/search_case_page_controller.dart';

class SearchCasePageView extends GetView<SearchCasePageController> {
  const SearchCasePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [_setSearchBarWidget(), _setSearchHistoryWidget()]),
    ).unfocusWhenTap();
  }

  Widget _setSearchBarWidget() {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: Container(
        height: AppScreenUtil.navigationBarHeight,
        width: AppScreenUtil.screenWidth,
        padding: EdgeInsets.only(
          top: AppScreenUtil.statusBarHeight,
          right: 12.toW,
        ),
        child: Row(
          children: [
            Container(
              width: 45.toW,
              height: 32.toW,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 4.toW),
              child: Icon(
                Icons.arrow_back_ios,
                size: 24.toW,
                color: Colors.black,
              ),
            ).withOnTap(() {
              Get.back();
            }),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.toW),
                color: AppColors.color_FFF3F3F3,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.toW),
              height: 32.toW,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: TextStyle(
                      color: AppColors.color_E6000000,
                      fontSize: 14.toSp,
                    ),
                    controller: controller.textEditingController,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      // 移除默认内边距
                      isDense: true,
                      // 关键：让装饰更紧凑
                      hintText: '搜索',
                      hintStyle: TextStyle(
                        color: AppColors.color_FFC5C5C5,
                        fontSize: 14.toSp,
                      ),
                    ),
                    onChanged: (text) {},
                    onSubmitted: (text) {
                      controller.searchCaseResult(text);
                    },
                  ).withExpanded(),
                  ImageUtils(
                    imageUrl: Assets.home.searchIcon.path,
                    width: 16.toW,
                    height: 16.toW,
                  ),
                ],
              ),
            ).withExpanded(), // 与左侧返回按钮宽度一致，保持对称
          ],
        ),
      ),
    );
  }

  Widget _setSearchHistoryWidget() {
    return Container(
      padding: EdgeInsets.only(
        top: AppScreenUtil.navigationBarHeight,
        left: 48.toW,
        right: 16.toW,
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Height(4.toSp),
          Text(
            '历史搜索',
            style: TextStyle(
              color: AppColors.color_66000000,
              fontSize: 12.toSp,
            ),
          ),
          Height(8.toW),
          SingleChildScrollView(
            child: Obx(
              () => Wrap(
                spacing: 12.toW,
                runSpacing: 5.toW,
                children: controller.historys
                    .map(
                      (e) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.toW),
                          color: AppColors.color_FFF3F3F3,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.toW,
                          vertical: 4.toW,
                        ),
                        child: Text(
                          e,
                          style: TextStyle(
                            color: AppColors.color_E6000000,
                            fontSize: 12.toSp,
                          ),
                        ),
                      ).withOnTap(() => controller.searchCaseResult(e)),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
