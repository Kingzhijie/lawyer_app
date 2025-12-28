import 'package:get/get.dart';

import '../controllers/contract_detail_page_controller.dart';

class ContractDetailPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContractDetailPageController>(
      () => ContractDetailPageController(),
    );
  }
}
