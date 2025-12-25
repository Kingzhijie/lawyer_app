import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';

class SearchCasePageController extends GetxController {
  List<String> historys = ['历史', '招律师', '18987878778'];

  final TextEditingController textEditingController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void searchCaseResult() {
    Get.toNamed(Routes.SEARCH_CASE_RSULT_PAGE, arguments: textEditingController.text);
  }

}
