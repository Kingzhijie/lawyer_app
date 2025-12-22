import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/common_app_bar.dart';

import '../controllers/chat_page_controller.dart';

class ChatPageView extends GetView<ChatPageController> {
  const ChatPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: '聊天', isShowLeading: false),
      body: const Center(
        child: Text(
          'ChatPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
