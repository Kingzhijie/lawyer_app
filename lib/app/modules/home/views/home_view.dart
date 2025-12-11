import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../widgets/chat_bottom_panel.dart';
import '../widgets/chat_bubble_left.dart';
import '../widgets/chat_bubble_right.dart';
import '../widgets/chat_input_bar.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 对话'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false, // 官方推荐保持 false，由控件管理键盘/面板切换
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: controller.hidePanel,
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  controller: controller.scrollController,
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    if (msg.isAi) {
                      return ChatBubbleLeft(
                        message: msg,
                        onAnimated: () => controller.markMessageAnimated(msg.id),
                        onTick: controller.scheduleScrollDuringTyping,
                      );
                    } else {
                      return ChatBubbleRight(message: msg);
                    }
                  },
                ),
              ),
            ),
            ChatInputBar(controller: controller),
            ChatBottomPanel(controller: controller),
          ],
        ),
      )
    );
  }
}
