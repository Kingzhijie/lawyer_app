import 'package:get/get.dart';

class VipCenterPageController extends GetxController {
  //TODO: Implement VipCenterPageController

  final count = 0.obs;

  final List<String> tags = ['套餐一', '套餐二', '套餐三'];
  var selectTag = Rx<String?>(null);

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
}
