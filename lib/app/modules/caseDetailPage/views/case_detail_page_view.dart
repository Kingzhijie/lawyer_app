import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/common_app_bar.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';

import '../../../common/components/tabPage/label_tab_bar.dart';
import '../../../common/constants/app_colors.dart';
import '../../../utils/screen_utils.dart';
import '../controllers/case_detail_page_controller.dart';
import 'widget/case_detail_base_info.dart';

class CaseDetailPageView extends GetView<CaseDetailPageController> {
  const CaseDetailPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: '案件详情'),
      body: Column(
        children: [
          CaseDetailBaseInfo(),
          _setTabWidget().withExpanded()
        ],
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
      padding: EdgeInsets.symmetric(horizontal: 12.toW),
      // isScrollable: true,
      indicatorWeight: 2.toW,
      bgColor: Colors.transparent,
      defaultSelectIndex: 0,
      height: 37.toW,
      labelColor: AppColors.theme,
      unselectedLabelColor: AppColors.color_E6000000,
      isShowBottomLine: true,
      labelStyle: TextStyle(
          color: AppColors.theme, fontSize: 14.toSp, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(color: AppColors.color_E6000000, fontSize: 14.toSp),
      indicator: _indicator,
      switchPageCallBack: (index) {
      },
    );
  }

  // 自定义 - 标签指示器
  Decoration get _indicator {
    return MyUnderlineTabIndicator(
      width: 16.toW,
      borderSide: BorderSide(
        width: 3.toW,
        color: AppColors.theme,
      ),
    );
  }


}
