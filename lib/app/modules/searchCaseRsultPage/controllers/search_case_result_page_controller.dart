import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/modules/searchCaseRsultSubPage/controllers/search_case_rsult_sub_page_controller.dart';
import 'package:lawyer_app/app/modules/searchCaseRsultSubPage/views/search_case_rsult_sub_page_view.dart';

import '../../../common/components/tabPage/label_tab_bar.dart';

enum LawyerTypeEnum {
  all('全部', 0),
  yuangao('原告', 1),
  beigao('被告', 2);

  const LawyerTypeEnum(this.name, this.type);

  final String name;
  final int type;
}

class SearchCaseResultPageController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();

  final FocusNode focusNode = FocusNode();

  List<LabelTopBarModel> tabModelArr = [];

  List<LawyerTypeEnum> titles = [
    LawyerTypeEnum.all,
    LawyerTypeEnum.yuangao,
    LawyerTypeEnum.beigao,
  ];

  @override
  void onInit() {
    super.onInit();
    textEditingController.text = Get.arguments;

    for (var e in titles) {
      tabModelArr.add(
        LabelTopBarModel(e.name, SearchCaseRsultSubPageView(type: e.type)),
      );
      Get.lazyPut<SearchCaseRsultSubPageController>(
            () => SearchCaseRsultSubPageController(),
        tag: e.type.toString(), // 使用 type 作为标签区分不同实例
        fenix: true, // 允许控制器被销毁后重新创建
      );
    }

  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // 删除每个标签对应的控制器
    for (var e in titles) {
      final tag = e.type.toString(); // 使用 type 作为 tag
      // 检查是否存在再删除
      if (Get.isRegistered<SearchCaseRsultSubPageController>(tag: tag)) {
        Get.delete<SearchCaseRsultSubPageController>(
          tag: tag,
          force: true,
        );
      }
    }
    super.onClose();
  }

  void searchCaseResult() {}
}
