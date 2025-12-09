import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:getuiflut/getuiflut.dart';

import '../../http/net/tool/logger.dart';
import '../device_info_utils.dart';
import '../permission_util.dart';

class PushUtil {
  static final Getuiflut pushUtil = Getuiflut();

  static String pushAppId = 'Omh21RFrHMAnXXOjPH7mY7';
  static String pushAppKey = 'W1XAkXoLAp8OdSigQM8OI4';
  static String pushAppSecret = 'Pp0hnL7cvt9GVQ2nuhE7G9';
  static final FlutterLocalNotificationsPlugin localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  ///初始化sdk
  static Future<bool> initPushSDK() async {
    /**
     *初始化个推sdk
     */
    if (Platform.isIOS) {
      try {
        pushUtil.startSdk(
          appId: pushAppId,
          appKey: pushAppKey,
          appSecret: pushAppSecret,
        );
        pushUtil.registerRemoteNotification();
        return true;
      } catch (e) {
        logPrint('推送初始化失败====$e');
        return false;
      }
    } else {
      try {
        initLocalNotifications();
        pushUtil.initGetuiSdk;
        //通知授权
        bool isPushAuth = await PermissionUtils.requestNotificationPermission(
          isToast: false,
        );
        logPrint('安卓获取推送权限====$isPushAuth');
        return true;
      } catch (e) {
        logPrint('推送初始化失败====$e');
        return false;
      }
    }
  }

  ///本地通知
  static Future<void> initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    await localNotificationsPlugin.initialize(
      InitializationSettings(
        android: androidSettings,
      ),
      onDidReceiveNotificationResponse: (NotificationResponse res) {
        logPrint('🔔 点击了通知: ${res.payload}');
      },
    );
  }

  // ///获取推送权限
  // static Future<void> getPushAuth() async {
  //   if (Platform.isIOS) {
  //     //通知授权,需要先启动sdk
  //     pushUtil.registerRemoteNotification();
  //   } else {
  //     //通知授权
  //     bool isPushAuth = await PermissionUtils.requestNotificationPermission(
  //       isToast: false,
  //     );
  //     logPrint('安卓获取推送权限====$isPushAuth');
  //   }
  // }

  ///个推推送监听
  static void addEventHandler() {
    logPrint('addPushEventHandler');
    pushUtil.setPushMode(1);
    runBackgroundEnable(false);

    pushUtil.addEventHandler(
      onReceiveClientId: (String message) async {
        logPrint("flutter onReceiveClientId: $message");
        // PushUtil.setAlias('mi4672364mi');
      },
      onReceiveOnlineState: (String online) async {
        logPrint("flutter onReceiveOnlineState: $online");
      },
      onReceivePayload: (Map<String, dynamic> message) async {
        logPrint("flutter onReceivePayload: $message");
        String msg = message['payloadMsg'].toString();
        onReceiveSilenceMessage(msg);
      },
      onSetTagResult: (Map<String, dynamic> message) async {
        logPrint("flutter onSetTagResult: $message");
      },
      onAliasResult: (Map<String, dynamic> message) async {
        logPrint("flutter onAliasResult: $message");
      },
      onQueryTagResult: (Map<String, dynamic> message) async {
        logPrint("flutter onQueryTagResult: $message");
      },
      onRegisterDeviceToken: (String message) async {
        logPrint("flutter onRegisterDeviceToken: $message");
        pushUtil.registerDeviceToken(message);
      },
      //Android 、ohos 特有
      onNotificationMessageArrived: (Map<String, dynamic> msg) async {
        logPrint("flutter onNotificationMessageArrived: $msg");
      },
      onNotificationMessageClicked: (Map<String, dynamic> msg) async {
        logPrint("flutter onNotificationMessageClicked: $msg");
      },
      //以下IOS特有
      onTransmitUserMessageReceive: (Map<String, dynamic> msg) async {
        logPrint("flutter onTransmitUserMessageReceive:$msg");
      },
      //通知点击
      onReceiveNotificationResponse: (Map<String, dynamic> message) async {
        logPrint("flutter onReceiveNotificationResponse: $message");
        String msg = message['payload'].toString();
        onClickReceiveNotificationResponse(msg);
      },
      onAppLinkPayload: (String message) async {
        logPrint("flutter onAppLinkPayload: $message");
      },
      onPushModeResult: (Map<String, dynamic> message) async {
        logPrint("flutter onPushModeResult: $message");
      },
      onWillPresentNotification: (Map<String, dynamic> message) async {
        logPrint("flutter onWillPresentNotification: $message");
      },
      onOpenSettingsForNotification: (Map<String, dynamic> message) async {
        logPrint("flutter onOpenSettingsForNotification: $message");
      },
      onGrantAuthorization: (String granted) async {
        logPrint("flutter onGrantAuthorization: $granted");
      },
      onLiveActivityResult: (Map<String, dynamic> message) async {
        logPrint("flutter onLiveActivityResult: $message");
      },
      onRegisterPushToStartTokenResult: (Map<String, dynamic> message) async {
        logPrint("flutter onRegisterPushToStartTokenResult: $message");
      },
    );
  }

  /// 设置别名
  static void setAlias(String alias) {
    logPrint('用户别名====$alias');
    pushUtil.bindAlias(alias, DeviceInfo.uuid?.replaceAll('-', '') ?? '');
  }

  /// 删除别名
  static void deleteAlias(String alias) {
    pushUtil.unbindAlias(
      alias,
      DeviceInfo.uuid?.replaceAll('-', '') ?? '',
      true,
    );
  }

  ///停止sdk
  static void turnOffPush() {
    pushUtil.turnOffPush();
  }

  ///开启sdk
  static void turnOnPush() {
    pushUtil.turnOnPush();
  }

  ///设置角标
  static void setBadge(int badge) {
    logPrint('badge====$badge');
    pushUtil.setBadge(badge);
    pushUtil.setLocalBadge(badge);
    if (badge == 0) {
      clearAllNotifications();
    }
  }

  ///复位服务器角标
  static void resetBadge() {
    pushUtil.resetBadge();
  }

  ///开启\关闭后台模式
  static void runBackgroundEnable(bool isOpen) {
    pushUtil.runBackgroundEnable(isOpen ? 1 : 0);
  }

  ///收到静默消息
  static void onReceiveSilenceMessage(String message) {
    if (message.isNotEmpty) {
      logPrint('收到静默消息message====$message');
    }
  }

  ///点击通知
  static void onClickReceiveNotificationResponse(String message) {

  }



  static Future<void> clearAllNotifications() async {
    if (Platform.isAndroid) {
      await localNotificationsPlugin.cancelAll();
    }
  }

  ///跳转到目标页面例如:  miyueapp://page/recharge-page
  static void pushTargetSchema(String? schema) {

  }


}
