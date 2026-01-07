import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/vip_center_page_controller.dart';

class VipCenterPageView extends GetView<VipCenterPageController> {
  const VipCenterPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VipCenterPageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'VipCenterPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
