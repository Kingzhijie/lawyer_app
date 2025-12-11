import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Listener(
              onPointerUp: (_) => controller.handleInputPointerUp(),
              child: NotificationListener<SizeChangedLayoutNotification>(
                onNotification: (_) {
                  controller.handleInputSizeChanged(Size.zero);
                  return false;
                },
                child: const SizeChangedLayoutNotifier(
                  child: _InputField(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Obx(() {
            final hasText = controller.hasText.value;
            return IconButton(
              icon: Icon(hasText ? Icons.send : Icons.add_circle_outline),
              onPressed: hasText
                  ? controller.handleSendPressed
                  : controller.handleToolBtnClick,
              iconSize: 28,
            );
          }),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return TextField(
      controller: controller.textController,
      focusNode: controller.inputFocusNode,
      minLines: 1,
      maxLines: 4, // 1-4 行内自适应，高度到 4 行后内部滚动
      keyboardType: TextInputType.multiline,
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
      onSubmitted: (text) {
        controller.handleSendPressed();
      },
      textInputAction: TextInputAction.send,
      onTap: controller.handleInputTap,
    );
  }
}

