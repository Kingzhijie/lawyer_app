import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      '聊天功能待实现',
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.textController,
                      focusNode: controller.inputFocusNode,
                      decoration: InputDecoration(
                        hintText: '请输入您要咨询的问题...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onTap: controller.handleInputTap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: controller.handleToolBtnClick,
                    iconSize: 28,
                  ),
                ],
              ),
            ),
            ChatBottomPanelContainer<ChatPanelType>(
              controller: controller.panelController,
              inputFocusNode: controller.inputFocusNode,
              panelBgColor: Colors.grey.shade100,
              otherPanelWidget: (type) {
                switch (type) {
                  case ChatPanelType.tool:
                    return _buildToolPanel();
                  default:
                    return const SizedBox.shrink();
                }
              },
              onPanelTypeChange: controller.onPanelTypeChange,
              // 移除自定义动画，使用默认切换以保证顺畅
            ),
          ],
        ),
      )
    );
  }

  Widget _buildToolPanel() {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.extension, size: 36, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            '功能面板占位区\n后续可在此添加自定义工具',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
