import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/modules/userInfoPage/views/widgets/edit_nickName_widget.dart';

import '../../../../main.dart';
import '../../../common/components/bottom_sheet_content_widget.dart';
import '../../../common/components/bottom_sheet_utils.dart';
import '../../../common/components/dialog.dart';
import '../../../common/constants/app_colors.dart';
import '../../../utils/cache_utils.dart';
import '../../../utils/image_crop_tool.dart';
import '../../../utils/image_picker_util.dart';
import '../../../utils/object_utils.dart';
import '../../../utils/screen_utils.dart';
import '../../../utils/toast_utils.dart';
import '../../myPage/models/user_model.dart';
import '../../newHomePage/controllers/new_home_page_controller.dart';

class UserInfoPageController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final count = 0.obs;

  ///用户信息
  var userModel = Rx<UserModel?>(null);

  var userIcon = Rx<String?>(null);
  var nickName = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    var homeController = getFindController<NewHomePageController>();
    userModel.value = homeController?.userModel.value;
    textEditingController.text = userModel.value?.nickname ?? '';
    userIcon.value = userModel.value?.avatar;
    nickName.value = textEditingController.text;
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
      ImageCropTool.cropImageAction(imageByte, (result, isSuc) {
        userIcon.value = result;
        if (isSuc) {
          editUserInfo();
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
        sureAction: (text) {
          nickName.value = text;
          editUserInfo();
        },
        textEditingController: textEditingController,
      ),
    );
  }

  ///编辑用户基本信息
  void editUserInfo() {
    NetUtils.put(
      Apis.editUserInfo,
      params: {
        'nickname': textEditingController.text,
        'avatar': userIcon.value,
        'sex': userModel.value?.sex ?? 1,
      },
    ).then((data) {
      if (data.code == NetCodeHandle.success) {
        showToast('用户信息更新成功');
        getFindController<NewHomePageController>()?.getUserInfo();
      }
    });
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
