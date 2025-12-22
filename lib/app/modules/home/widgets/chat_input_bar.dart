import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';

import '../controllers/home_controller.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key, required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.toW, vertical: 8.toW),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.color_line, width: 0.5))
      ),
      child: Obx(() {
        final hasText = controller.hasText.value;
        final hasVoice = controller.hasVoice.value;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!hasVoice)
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
              )
            else
              Expanded(
                child: GestureDetector(
                  onLongPressStart: (details) {
                    controller.startRecording(details.globalPosition);
                  },
                  onLongPressEnd: (details) {
                    if (controller.isCancelMode.value) {
                      controller.cancelRecording();
                    } else {
                      controller.stopRecording();
                    }
                  },
                  onLongPressMoveUpdate: (details) {
                    controller.checkCancelMode(details.globalPosition);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 13.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade100,
                    ),
                    child: const Text('按住说话'),
                  ),
                ),
              ),
            if (!hasText)
              IconButton(
                icon: Icon(
                  hasVoice
                      ? Icons.keyboard_alt_outlined
                      : Icons.volume_up_outlined,
                ),
                onPressed: controller.handleVoicePressed,
                iconSize: 28,
              ).withMarginOnly(left: 8),
            IconButton(
              icon: Icon(hasText ? Icons.send : Icons.add_circle_outline),
              onPressed: hasText
                  ? controller.handleSendPressed
                  : controller.handleToolBtnClick,
              iconSize: 28,
            ).withMarginOnly(left:hasText ? 8 : 0),
          ],
        );
      }),
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
      maxLines: 4,
      // 1-4 行内自适应，高度到 4 行后内部滚动
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
