import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/common_app_bar.dart';

import '../controllers/new_home_page_controller.dart';

class NewHomePageView extends GetView<NewHomePageController> {
  const NewHomePageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: '首页', isShowLeading: false),
      body: const Center(
        child: Text(
          'NewHomePageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
