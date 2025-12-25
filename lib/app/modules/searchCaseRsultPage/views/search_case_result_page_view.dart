import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../common/components/tabPage/label_tab_bar.dart';
import '../../../common/constants/app_colors.dart';
import '../../../common/extension/widget_extension.dart';
import '../../../utils/image_utils.dart';
import '../../../utils/screen_utils.dart';
import '../controllers/search_case_result_page_controller.dart';

class SearchCaseResultPageView extends GetView<SearchCaseResultPageController> {
  const SearchCaseResultPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [_setSearchBarWidget(),
        Container(
          margin: EdgeInsets.only(top: AppScreenUtil.navigationBarHeight),
          child: _setTabWidget(),
        ),
      ]),
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
                    // controller: _controller,
                    autofocus: false,
                    focusNode: controller.focusNode,
                    controller: controller.textEditingController,
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
                      controller.searchCaseResult();
                    },
                  ).withExpanded(),
                  ImageUtils(
                    imageUrl: Assets.common.closeTfIcon.path,
                    width: 16.toW,
                    height: 16.toW,
                  ).withOnTap((){
                    controller.textEditingController.text = '';
                    controller.focusNode.requestFocus();
                  }),
                ],
              ),
            ).withExpanded(), // 与左侧返回按钮宽度一致，保持对称
          ],
        ),
      ),
    );
  }

  // 自定义头部标签
  Widget _setTabWidget() {
    if (controller.tabModelArr.isEmpty) {
      return Container();
    }
    return LabelTabBar(
      controller.tabModelArr,
      padding: EdgeInsets.symmetric(horizontal: 20.toW),
      // isScrollable: true,
      indicatorWeight: 2.toW,
      bgColor: Colors.transparent,
      defaultSelectIndex: 0,
      height: 42.toW,
      labelColor: AppColors.color_E6000000,
      unselectedLabelColor: AppColors.color_66000000,
      isShowBottomLine: false,
      labelStyle: TextStyle(
          color: AppColors.color_E6000000, fontSize: 14.toSp),
      unselectedLabelStyle: TextStyle(color: AppColors.color_66000000, fontSize: 14.toSp),
      indicator: _indicator,
      switchPageCallBack: (index) {
      },
    );
  }

  // 自定义 - 标签指示器
  Decoration get _indicator {
    return MyUnderlineTabIndicator(
      width: 14.toW,
      borderSide: BorderSide(
        width: 2.toW,
        color: AppColors.color_E6000000,
      ),
    );
  }

}
