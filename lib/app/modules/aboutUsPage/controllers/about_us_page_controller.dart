import 'package:get/get.dart';
import 'package:lawyer_app/app/routes/app_pages.dart';

class AboutUsPageController extends GetxController {
  /// 打开用户服务协议
  void openUserServiceAgreement() {
    Get.toNamed(
      Routes.WEB_VIEW_PAGE,
      arguments: {
        'title': '用户服务协议',
        'assetPath': 'assets/html/user_agreement.html',
      },
    );
  }

  /// 打开隐私政策
  void openPrivacyPolicy() {
    Get.toNamed(
      Routes.WEB_VIEW_PAGE,
      arguments: {'title': '隐私政策', 'url': 'http://lingb.lawseek.cn/yszc.html'},
    );
  }
}
