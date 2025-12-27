import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_info_page_controller.dart';

class UserInfoPageView extends GetView<UserInfoPageController> {
  const UserInfoPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UserInfoPageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UserInfoPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
