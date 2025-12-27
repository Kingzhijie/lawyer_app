import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../../controllers/chat_page_controller.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key, required this.controller});

  final ChatPageController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.toW, vertical: 8.toW),
      padding: EdgeInsets.symmetric(horizontal: 16.toW),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
        borderRadius: BorderRadius.circular(12.toW),
      ),
      child: Obx(() {
        final hasText = controller.hasText.value;
        final hasVoice = controller.hasVoice.value;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageUtils(
              imageUrl: Assets.common.addPhotoIcon.path,
              width: 24.toW,
            ),
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
                    padding: EdgeInsets.symmetric(vertical: 12.toW),
                    child: Text(
                      '按住说话',
                      style: TextStyle(
                        color: AppColors.color_E6000000,
                        fontSize: 16.toSp,
                      ),
                    ),
                  ),
                ),
              ),
            if (!hasText)
              ImageUtils(
                    imageUrl: hasVoice
                        ? Assets.common.jianpanIcon.path
                        : Assets.common.voiceChangeIcon.path,
                    width: 24.toW,
                  )
                  .withOnTap(() {
                    controller.handleVoicePressed();
                  })
                  .withMarginOnly(right: 8.toW),

            ImageUtils(
                  imageUrl: hasText
                      ? Assets.home.sendIcon.path
                      : Assets.common.addActionIcon.path,
                  width: 24.toW,
                )
                .withOnTap(() {
                  if (hasText) {
                    controller.handleSendPressed();
                  } else {
                    controller.handleToolBtnClick();
                  }
                })
                .withMarginOnly(left: hasText ? 8.toW : 0),
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
    final controller = Get.find<ChatPageController>();
    return TextField(
      controller: controller.textController,
      focusNode: controller.inputFocusNode,
      minLines: 1,
      maxLines: 4,
      style: TextStyle(color: AppColors.color_E6000000, fontSize: 16.toSp),
      // 1-4 行内自适应，高度到 4 行后内部滚动
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: '问一问灵伴...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        hintStyle: TextStyle(
          color: AppColors.color_66000000,
          fontSize: 16.toSp,
        ),
        fillColor: Colors.transparent,
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
