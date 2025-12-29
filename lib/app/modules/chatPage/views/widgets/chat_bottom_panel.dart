import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/chatPage/controllers/chat_page_controller.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

enum ActionType {
  camera,
  photo,
  file
}

class ChatBottomPanel extends StatelessWidget {
  final ChatPageController controller;
  const ChatBottomPanel({super.key, required this.controller});


  @override
  Widget build(BuildContext context) {
    return ChatBottomPanelContainer<ChatPanelType>(
      controller: controller.panelController,
      inputFocusNode: controller.inputFocusNode,
      panelBgColor: Colors.white.withOpacity(0.1),
      otherPanelWidget: (type) {
        switch (type) {
          case ChatPanelType.tool:
            return ToolPanel(clickAction: (type){
              controller.clickAction(type);
            },);
          default:
            return const SizedBox.shrink();
        }
      },
      onPanelTypeChange: controller.onPanelTypeChange,
      // 默认切换，无额外动画
    );
  }
}

class ToolPanel extends StatelessWidget {
  final Function(ActionType type) clickAction;
  const ToolPanel({super.key, required this.clickAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300.toW,
      padding: EdgeInsets.symmetric(horizontal: 24.toW, vertical: 15.toW),
      alignment: Alignment.topCenter,
      child: Row(
        children: [
          _setItem(ActionType.camera),
          Width(7.toW),
          _setItem(ActionType.photo),
          Width(7.toW),
          _setItem(ActionType.file),
        ],
      ),
    );
  }

  Widget _setItem(ActionType type){
    return Container(
      width: 77.toW,
      height: 82.toW,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.color_FFF5F7FA,
              borderRadius: BorderRadius.circular(12.toW)
            ),
            width: 54.toW,
            height: 54.toW,
            alignment: Alignment.center,
            child: ImageUtils(imageUrl: _getIcon(type), width: 24.toW),
          ),
          Text(_getName(type), style: TextStyle(color: AppColors.color_E6000000, fontSize: 14.toSp),)
        ],
      ),
    ).withOnTap((){
      clickAction(type);
    });
  }

  String _getName(ActionType type){
    switch (type) {
      case ActionType.camera:
        return '相机';
      case ActionType.photo:
        return '相册';
      case ActionType.file:
        return '文件';
    }
  }

  String _getIcon(ActionType type){
    switch (type) {
      case ActionType.camera:
        return Assets.common.actionXiangjiIcon.path;
      case ActionType.photo:
        return Assets.common.actionImgIcon.path;
      case ActionType.file:
        return Assets.common.actionFileIcon.path;
    }
  }

}

