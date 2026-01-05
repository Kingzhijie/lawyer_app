import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';
import 'package:lawyer_app/app/utils/storage_utils.dart';
import 'package:lawyer_app/generated/l10n.dart';

class SearchCasePageController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  RxList<String> historys = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    historys.value = StorageUtils.getStringList(StorageKey.taskSearchKey) ?? [];
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }

  void searchCaseResult(String searchText) {
    if (searchText.isNotEmpty) {
      addSearchHistoryRecord(searchText);
    }

    Get.toNamed(Routes.SEARCH_CASE_RSULT_PAGE, arguments: searchText);
  }

  void addSearchHistoryRecord(String searchText) {
    if (historys.length < 20) {
      if (historys.contains(searchText)) {
        historys.remove(searchText);
      }
      historys.insert(0, searchText);
      StorageUtils.setStringList(StorageKey.taskSearchKey, historys.value);
    }
  }
}
