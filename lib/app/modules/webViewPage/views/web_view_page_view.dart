import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../utils/screen_utils.dart';
import '../controllers/web_view_page_controller.dart';

class WebViewPageView extends GetView<WebViewPageController> {
  const WebViewPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Obx(
          () => Text(
            controller.title.value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // WebView 层（始终存在，避免重建）
          Obx(() {
            if (controller.htmlContent.value.isEmpty) {
              return const SizedBox.shrink();
            }

            // 判断是 URL 还是 HTML 内容
            final isUrl = controller.url != null;

            return InAppWebView(
              initialUrlRequest: isUrl
                  ? URLRequest(url: WebUri(controller.htmlContent.value))
                  : null,
              initialData: !isUrl
                  ? InAppWebViewInitialData(
                      data: controller.htmlContent.value,
                      baseUrl: WebUri('about:blank'),
                      encoding: 'utf-8',
                      mimeType: 'text/html',
                    )
                  : null,
              initialSettings: InAppWebViewSettings(
                transparentBackground: true,
                disableContextMenu: true,
                supportZoom: false,
                useOnLoadResource: true,
                javaScriptEnabled: true,
                javaScriptCanOpenWindowsAutomatically: false,
                mediaPlaybackRequiresUserGesture: true,
                allowFileAccessFromFileURLs: false,
                allowUniversalAccessFromFileURLs: false,
              ),
              onWebViewCreated: (webViewController) {
                controller.webViewController = webViewController;
              },
              onReceivedError: (webViewController, request, error) {
                controller.errorMessage.value = '加载失败: ${error.description}';
              },
            );
          }),

          // Loading 层
          Obx(() {
            if (!controller.isLoading.value) {
              return const SizedBox.shrink();
            }

            return Container(
              color: Colors.white,
              child: const Center(child: CircularProgressIndicator()),
            );
          }),

          // Error 层
          Obx(() {
            if (controller.errorMessage.value.isEmpty) {
              return const SizedBox.shrink();
            }

            return Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60.toW,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 16.toW),
                    Text(
                      controller.errorMessage.value,
                      style: TextStyle(
                        fontSize: 14.toSp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 20.toW),
                    ElevatedButton(
                      onPressed: () => controller.loadContent(),
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
