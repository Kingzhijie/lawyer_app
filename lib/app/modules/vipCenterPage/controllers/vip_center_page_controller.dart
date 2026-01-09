import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/modules/newHomePage/controllers/new_home_page_controller.dart';
import 'package:lawyer_app/app/modules/vipCenterPage/models/member_item_model.dart';
import 'package:lawyer_app/app/modules/vipCenterPage/views/widgets/vip_success_pop.dart';
import 'package:lawyer_app/app/utils/html_praser.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';

class VipCenterPageController extends GetxController {
  final count = 0.obs;

  final RxList<MemberItemModel> memberList = <MemberItemModel>[].obs;
  var selectMemberTag = Rx<MemberItemModel?>(null);

  @override
  void onInit() {
    super.onInit();
    getMemberList();
  }

  void getMemberList() async {
    var result = await NetUtils.get(Apis.memberPageList, isLoading: false);
    if (result.code == NetCodeHandle.success) {
      memberList.value = (result.data as List)
          .map((e) => MemberItemModel.fromJson(e))
          .toList();
      if (memberList.isNotEmpty) {
        selectMemberTag.value = memberList.first;
      }
    }
  }

  void onCreatePayOrder() async {
    var result = await NetUtils.post(
      Apis.createMemberOrder,
      params: {'memberPkgId': selectMemberTag.value!.id},
      isLoading: true,
    );
    if (result.code == NetCodeHandle.success) {
      // final payOrderId = result.data['payOrderId'] as int? ?? '';
    }
  }

  void getMemberOrder(int payOrderId) async {
    var result = await NetUtils.post(
      Apis.memberOrder,
      params: {'id': payOrderId},
      isLoading: true,
    );
    if (result.code == NetCodeHandle.success) {
      final status = result.data['status'] as int? ?? 0;
      if (status == 10) {
        getFindController<NewHomePageController>()?.getUserInfo();
        Get.dialog(
          VipSuccessPop(
            onConfirmTap: () {
              debugPrint('开通会员成功，刷新数据');
            },
          ),
        );
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
