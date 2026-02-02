import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../http/net/tool/logger.dart';

class WebViewPageController extends GetxController {
  InAppWebViewController? webViewController;

  var title = ''.obs;
  var htmlContent = ''.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  // 从路由参数获取
  String? assetPath;
  String? url;
  String? htmlString;

  @override
  void onInit() {
    super.onInit();

    // 获取路由参数
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      title.value = args['title'] ?? '';
      assetPath = args['assetPath'];
      url = args['url'];
      htmlString = args['html'];
    }

    logPrint('[WebView] 初始化，标题: ${title.value}, assetPath: $assetPath');
    loadContent();
  }

  /// 加载内容
  Future<void> loadContent() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      logPrint('[WebView] 开始加载内容');

      if (assetPath != null) {
        // 从 assets 加载
        logPrint('[WebView] 从 assets 加载: $assetPath');
        final content = await rootBundle.loadString(assetPath!);
        htmlContent.value = content;
        logPrint('[WebView] 加载成功，内容长度: ${content.length}');
      } else if (htmlString != null) {
        // 直接使用传入的 HTML 字符串
        htmlContent.value = htmlString!;
        logPrint('[WebView] 使用传入的 HTML 字符串');
      } else if (url != null) {
        // 从 URL 加载 - 直接让 WebView 加载 URL
        htmlContent.value = url!;
        logPrint('[WebView] 从 URL 加载: $url');
      } else {
        errorMessage.value = '未提供内容源';
        logPrint('[WebView] 未提供内容源');
      }

      // 延迟一下再关闭 loading，确保 WebView 有时间渲染
      await Future.delayed(const Duration(milliseconds: 500));
      isLoading.value = false;
      logPrint('[WebView] 加载完成');
    } catch (e, stackTrace) {
      isLoading.value = false;
      errorMessage.value = '加载失败: $e';
      logPrint('[WebView] 加载失败: $e');
      logPrint('[WebView] 堆栈: $stackTrace');
    }
  }

  @override
  void onClose() {
    webViewController = null;
    super.onClose();
  }
}
