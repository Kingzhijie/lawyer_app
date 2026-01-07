import 'package:get/get.dart';

import '../controllers/invite_friend_page_controller.dart';

class InviteFriendPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InviteFriendPageController>(
      () => InviteFriendPageController(),
    );
  }
}
