import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/chatPage/views/widgets/chat_bottom_panel.dart';
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
      padding: EdgeInsets.symmetric(horizontal: 12.toW),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: const Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.circular(12.toW),
      ),
      child: Obx(() {
        final hasText = controller.hasText.value;
        final hasVoice = controller.hasVoice.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (controller.images.isNotEmpty) _setImageWidget(),
            if (controller.files.isNotEmpty) _setFilesWidget(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageUtils(
                  imageUrl: Assets.common.addPhotoIcon.path,
                  width: 24.toW,
                ).withOnTap(() {
                  controller.clickAction(ActionType.photo);
                }),
                if (!hasVoice)
                  Flexible(
                    child: _InputField(),
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
                        color: Colors.white,
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
                        controller.handleSendPressed(isFocus: false);
                      } else {
                        controller.handleToolBtnClick();
                      }
                    })
                    .withMarginOnly(left: hasText ? 8.toW : 0),
              ],
            ),
          ],
        );
      }),
    );
  }

  ///设置image
  Widget _setImageWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.images
            .map(
              (e) => Stack(
                children: [
                  ImageUtils(
                    imageUrl: e.path ?? e.url,
                    width: 60.toW,
                    height: 60.toW,
                    circularRadius: 5.toW,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child:
                        Container(
                          width: 20.toW,
                          height: 20.toW,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(10.toW),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 12.toW,
                            color: Colors.white,
                          ),
                        ).withOnTap(() {
                          controller.images.remove(e);
                          controller.images.refresh();
                        }),
                  ),
                ],
              ).withMarginOnly(right: 6.toW, top: 6.toW),
            )
            .toList(),
      ),
    ).withMarginOnly(bottom: 12.toW);
  }

  ///设置文件
  Widget _setFilesWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: controller.files
            .map(
              (e) => Stack(
                children: [
                  Container(
                    width: 120.toW,
                    height: 80.toW,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.toW),
                      border: Border.all(
                        color: AppColors.color_line,
                        width: 0.5,
                      ),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8.toW),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (e.name ?? '').replaceAll('.${e.type}', ''),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.color_E6000000,
                            fontSize: 13.toSp,
                          ),
                        ),
                        Height(2.toW),
                        Row(
                          children: [
                            ImageUtils(
                              imageUrl: Assets.common.actionFileIcon.path,
                              width: 16.toW,
                            ),
                            Text(
                              e.type ?? '.pdf',
                              style: TextStyle(
                                color: AppColors.color_E6000000,
                                fontSize: 12.toSp,
                              ),
                            ).withExpanded(),
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child:
                        Container(
                          width: 20.toW,
                          height: 20.toW,
                          child: Icon(
                            Icons.close,
                            size: 14.toW,
                            color: Colors.black,
                          ),
                        ).withOnTap(() {
                          controller.files.remove(e);
                          controller.files.refresh();
                        }),
                  ),
                ],
              ).withMarginOnly(right: 6.toW, top: 6.toW),
            )
            .toList(),
      ),
    ).withMarginOnly(bottom: 12.toW);
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
