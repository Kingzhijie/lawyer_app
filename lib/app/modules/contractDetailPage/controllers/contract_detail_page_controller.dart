import 'package:get/get.dart';

class ContractDetailPageController extends GetxController {
  final RxInt trialIndex = 0.obs; // 0-一审, 1-二审, 2-再审

  void switchTrial(int index) {
    trialIndex.value = index;
  }
}
