import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'app/common/components/router_navigator_observer.dart';
import 'app/common/constants/app_colors.dart';
import 'app/http/net/tool/logger.dart';
import 'app/routes/app_pages.dart';

import 'app/utils/app_common_instance.dart';
import 'app/utils/loading.dart';
import 'app/utils/push/pushUtil.dart';
import 'app/utils/screen_utils.dart';
import 'main.dart';
import 'dart:ui' as ui;


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  StreamSubscription? _sub;
  final appLinks = AppLinks();

  @override
  void dispose() {
    super.dispose();
    _sub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();
    _init();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: AppScreenUtil.defaultSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (mContext, child) {
          return GetMaterialApp(
            title: "灵动",
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            navigatorObservers: [RouteHistoryObserver()],
            locale: const Locale('zh', 'CH'),
            theme: ThemeData(
              dividerColor: Colors.transparent,
              scaffoldBackgroundColor: AppColors.color_white,
              fontFamily: Platform.isIOS ? 'PingFang SC' : 'NotoSansSC',
              appBarTheme: AppBarTheme(
                scrolledUnderElevation: 0.0,
              ),
              platform: TargetPlatform.iOS,
              pageTransitionsTheme: const PageTransitionsTheme(builders: {
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              }),
            ),
            builder: EasyLoading.init(),
          );
        });
  }

  Future<void> _init() async {
    LoadingTool.configLoading();
    // _handleIncomingLinks();
  }

  //处理scheme 例如: miyueapp://page/my-scan-page?name=123
  // void _handleIncomingLinks() {
  //   _sub = appLinks.uriLinkStream.listen((Uri? uri) {
  //     if (!mounted || uri == null) return;
  //     _schemeJump(uri);
  //   }, onError: (Object err) {
  //     logPrint('got err: $err');
  //   });
  // }
  //
  //
  // //拿到scheme, 做处理
  // void _schemeJump(Uri link) {
  //   if (link.scheme == WxConfig.appScheme) {
  //     //appScheme, 打开APP
  //     _commonOpenPage(link);
  //   }
  //   // else if (link.host == Uri.parse(WxConfig.universalLink).host) {
  //   //   // universalLink 打开app
  //   //   _commonOpenPage(link);
  //   // }
  //   logPrint(link.scheme);
  //   logPrint(link.host);
  //   logPrint(link.path);
  //   logPrint(link.query);
  // }

  _commonOpenPage(Uri link) {
    // PushUtil.pushTargetSchema(link.toString());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      //进入应用时候不会触发该状态 应用程序处于可见状态，并且可以响应用户的输入事件。它相当于 Android 中Activity的onResume
      case AppLifecycleState.resumed:
        logPrint("应用进入前台======");
        AppInfoUtils.instance.isAlertDialog = false;
        if (!AppCommonUtils.getIsFirstInstall) {
          PushUtil.setBadge(0);
        }
        break;
      //应用状态处于闲置状态，并且没有用户的输入事件，
      // 注意：这个状态切换到 前后台 会触发，所以流程应该是先冻结窗口，然后停止UI
      case AppLifecycleState.inactive:
        logPrint("应用处于闲置状态，这种状态的应用应该假设他们可能在任何时候暂停 切换到后台会触发======");
        break;
      //当前页面即将退出
      case AppLifecycleState.detached:
        logPrint("当前页面即将退出======");
        break;
      // 应用程序处于不可见状态
      case AppLifecycleState.paused:
        logPrint("应用处于不可见状态 后台======");
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }
}

