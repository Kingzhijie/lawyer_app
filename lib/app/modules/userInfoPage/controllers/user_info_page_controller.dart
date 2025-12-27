import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/modules/userInfoPage/views/widgets/edit_nickName_widget.dart';

import '../../../../main.dart';
import '../../../common/components/bottom_sheet_content_widget.dart';
import '../../../common/components/bottom_sheet_utils.dart';
import '../../../common/components/dialog.dart';
import '../../../common/constants/app_colors.dart';
import '../../../utils/cache_utils.dart';
import '../../../utils/image_crop_tool.dart';
import '../../../utils/image_picker_util.dart';
import '../../../utils/screen_utils.dart';
import '../../../utils/toast_utils.dart';

class UserInfoPageController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final count = 0.obs;
  final userIcon = ''.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  /// 更换头像
  void changeAvatar() {
    BottomSheetUtils.show(
      currentContext,
      isShowCloseIcon: false,
      radius: 12.toR,
      isSetBottomInset: false,
      backgroundColor: Colors.white,
      contentWidget: BottomSheetContentWidget(
        contentModels: [
          BottomSheetContentModel(
            name: '相册',
            index: 1,
            textColor: AppColors.color_E6000000,
          ),
          BottomSheetContentModel(
            name: '拍摄',
            index: 2,
            textColor: AppColors.color_E6000000,
          ),
        ],
        clickItemCallBack: (contentModel) async {
          if (contentModel.index == 1) {
            choosePhotoMethod(1);
          } else if (contentModel.index == 2) {
            choosePhotoMethod(2);
          }
        },
      ),
    );
  }

  Future<void> choosePhotoMethod(int type) async {
    var file = await ImagePickerUtil.takePhotoOrFromLibrary(
      imageSource: type == 1 ? ImageSourceType.gallery : ImageSourceType.camera,
    );
    Uint8List? imageByte = await file?.readAsBytes();
    if (imageByte != null) {
      ImageCropTool.cropImageAction(imageByte, (result){
        if (result?['imageUrl'] != null) {
          userIcon.value = result!['imageUrl']!;
          // userModel.value?.avatarId = result?['imageId'] ?? '';
          // userModel.refresh();
        }
      });
    }

  }

  /// 编辑昵称
  void editNickname() {
    textEditingController.text = '';
    BottomSheetUtils.show(
      currentContext,
      isShowCloseIcon: false,
      radius: 12.toW,
      contentWidget: EditNicknameWidget(
        sureAction: (text) {},
        textEditingController: textEditingController,
      ),
    );
  }

  /// 清理缓存
  void clearCache() {
    AppDialog.doubleItem(
      title: '温馨提示',
      titleStyle: TextStyle(
        color: Colors.black,
        fontSize: 17.toSp,
        fontWeight: FontWeight.w600,
      ),
      content: '是否确认清除缓存？',
      contentStyle: TextStyle(color: Colors.black, fontSize: 15.toSp),
      cancel: '取消',
      confirm: '确认清除',
      onConfirm: () {
        CacheUtils.clear();
        showToast('缓存清除成功');
      },
    ).showAlert();
  }
}
