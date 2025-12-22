import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/common_app_bar.dart';

import '../controllers/agency_page_controller.dart';

class AgencyPageView extends GetView<AgencyPageController> {
  const AgencyPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: '待办事项',isShowLeading: false),
      body: const Center(
        child: Text(
          'AgencyPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
