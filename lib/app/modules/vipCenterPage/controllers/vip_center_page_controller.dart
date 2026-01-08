import 'package:get/get.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/modules/vipCenterPage/models/member_item_model.dart';

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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
