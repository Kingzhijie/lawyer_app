import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/common/constants/app_colors.dart';
import 'app/utils/storage_utils.dart';
import 'main_page.dart';


/// 全局路由key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
/// 当前的context
BuildContext get currentContext => navigatorKey.currentContext!;

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  await StorageUtils.initSharedPreferences();
  // if (binding.rootElement != null) {
  //   await precacheImage(
  //       AssetImage(Assets.images.common.mlyLaunchImg.path), binding.rootElement!);
  // }
  if (Platform.isAndroid) {
    SystemUiOverlayStyle style = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.color_FFF5F5F5,
    );
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  // 设置竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      const MainPage(),
    );
  });

}
