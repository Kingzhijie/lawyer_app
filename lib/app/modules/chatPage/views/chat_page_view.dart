import 'package:flutter/material.dart';

import 'package:lawyer_app/app/common/components/common_app_bar.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/chatPage/views/widgets/chat_bottom_panel.dart';
import 'package:lawyer_app/app/modules/chatPage/views/widgets/chat_bubble_left.dart';
import 'package:lawyer_app/app/modules/chatPage/views/widgets/chat_bubble_right.dart';
import 'package:lawyer_app/app/modules/chatPage/views/widgets/chat_input_bar.dart';
import 'package:lawyer_app/app/modules/chatPage/views/widgets/no_find_case_widget.dart';
import 'package:lawyer_app/app/modules/chatPage/views/widgets/voice_recording_overlay.dart';

import '../../../../gen/assets.gen.dart';
import '../../../common/constants/app_colors.dart';
import '../../../utils/image_utils.dart';
import '../../../utils/screen_utils.dart';
import '../controllers/chat_page_controller.dart';
import 'package:get/get.dart';

class ChatPageView extends GetView<ChatPageController> {
  const ChatPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 官方推荐保持 false，由控件管理键盘/面板切换
      body: Stack(
        children: [
          // 背景
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: ImageUtils(
              imageUrl: Assets.home.homeBg.path,
              width: AppScreenUtil.screenWidth,
            ),
          ),
          _buildTopBar(context),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: controller.hidePanel,
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    if (controller.isShowNoCase.value) {
                      return SingleChildScrollView(
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          height:
                              AppScreenUtil.screenHeight -
                              AppScreenUtil.navigationBarHeight -
                              AppScreenUtil.bottomBarHeight -
                              80.toW,
                          child: NoFindCaseWidget(),
                        ).unfocusWhenTap(),
                      );
                    }
                    // 使用 reverse: true 模式，新消息自动出现在底部
                    // 消息少时使用 shrinkWrap + Align 让消息显示在顶部
                    final reversedMessages = controller.messages.reversed.toList();
                    final useShrinkWrap = reversedMessages.length <= 10;
                    return Align(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                        reverse: true,
                        shrinkWrap: useShrinkWrap,
                        controller: controller.scrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.toW,
                          vertical: 16.toW,
                        ),
                        itemCount: reversedMessages.length,
                        itemBuilder: (context, index) {
                          final msg = reversedMessages[index];
                          if (msg.isAi) {
                            return ChatBubbleLeft(
                              message: msg,
                              onAnimated: () =>
                                  controller.markMessageAnimated(msg.id),
                              onTick: () {}, // reverse 模式不需要滚动
                            );
                          } else {
                            return ChatBubbleRight(message: msg);
                          }
                        },
                      ),
                    );
                  }),
                ),
                ChatInputBar(controller: controller),
                ChatBottomPanel(controller: controller),
              ],
            ),
          ).withMarginOnly(top: AppScreenUtil.navigationBarHeight),
          // Obx(() {
          //   if (controller.isShowNoCase.value) {
          //     return Positioned(
          //       bottom: AppScreenUtil.bottomBarHeight +
          //           80.toW,
          //       left: 0,
          //       right: 0,
          //       child: SingleChildScrollView(
          //         child: Container(
          //           alignment: Alignment.bottomCenter,
          //           height:
          //           AppScreenUtil.screenHeight -
          //               AppScreenUtil.navigationBarHeight -
          //               AppScreenUtil.bottomBarHeight -
          //               80.toW,
          //           child: NoFindCaseWidget(),
          //         ).unfocusWhenTap(),
          //       ),
          //     );
          //   }
          //   return Container();
          // }),
          // 录音界面覆盖层
          Obx(() {
            if (!controller.isRecording.value) {
              return const SizedBox.shrink();
            }
            return const VoiceRecordingOverlay();
          }),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: Container(
        height: AppScreenUtil.navigationBarHeight,
        padding: EdgeInsets.only(top: AppScreenUtil.statusBarHeight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 34.toW,
              height: 34.toW,
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 22.toW,
              ),
            ).withOnTap(() {
              Get.back();
            }),
            Text(
              'AI对话',
              style: TextStyle(
                fontSize: 18.toSp,
                fontWeight: FontWeight.w600,
                color: AppColors.color_E6000000,
              ),
            ),
            SizedBox(width: 34.toW),
          ],
        ),
      ),
    );
  }
}
