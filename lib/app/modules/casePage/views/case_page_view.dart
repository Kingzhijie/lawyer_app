import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../common/components/common_app_bar.dart';
import '../controllers/case_page_controller.dart';

class CasePageView extends GetView<CasePageController> {
  const CasePageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: '案件', isShowLeading: false),
      body: const Center(
        child: Text(
          'CasePageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
