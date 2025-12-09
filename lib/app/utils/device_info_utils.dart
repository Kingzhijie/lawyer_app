import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../common/constants/enum/app_enum.dart';

/// 设备信息工具类
class DeviceInfo {
  ///APP名字
  static String? appName;

  /// APP版本号
  static String? version;

  /// APP构建版本号
  static String? buildNumber;

  /// 设备品牌
  static String? brand;

  /// 设备型号
  static String? deviceModel;

  /// 设备系统号
  static String? deviceSystemVersion;

  /// 设备唯一码
  static String? uuid;

  /// 设备oaid
  static String? oaid;

  /// 包名
  static String? packageName;

  static String? sdkInt;

  ///获取当前应用版本信息
  static appVersion() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    packageName = info.packageName;
    version = info.version;
    buildNumber = info.buildNumber;
    appName = info.appName;
    uuid = Uuid().v1();
  }

  ///获取设备信息
  static deviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo? androidInfo;
    IosDeviceInfo? iosInfo;
    // uuid = await FlutterUdid.udid;
    if (Platform.isIOS) {
      iosInfo = await deviceInfoPlugin.iosInfo;
    } else if (Platform.isAndroid) {
      androidInfo = await deviceInfoPlugin.androidInfo;
      // final supported = await OaidUtils.isOaidSupported();
      // if (supported) {
      //   oaid = await OaidUtils.getOaid64();
      // }
    }
    Map<String, dynamic> deviceData = {};
    deviceData = _readDeviceInfo(androidInfo, iosInfo);
    brand = deviceData['brand'].toString();
    uuid = deviceData['uuid'].toString();
    deviceModel = deviceData['deviceModel'].toString();
    deviceSystemVersion = deviceData['systemVersion'].toString();
    sdkInt = deviceData['sdkInt'].toString();
  }
  // xiaomi, huawei, vivo, oppo, honor, common, yyd, 360

  static _readDeviceInfo(
      AndroidDeviceInfo? androidInfo, IosDeviceInfo? iosInfo) {
    Map<String, dynamic> data = <String, dynamic>{
      // 手机型号
      "deviceModel": Platform.isIOS ? iosInfo?.model : androidInfo?.model,
      "deviceId": androidInfo?.id,
      //手机品牌加型号
      "brand": Platform.isIOS ? iosInfo?.name : androidInfo?.brand,
      //当前系统版本
      "systemVersion": Platform.isIOS
          ? iosInfo?.systemVersion
          : androidInfo?.version.release,
      //当前安卓API Level
      "sdkInt": Platform.isIOS
          ? iosInfo?.systemVersion
          : androidInfo?.version.sdkInt,
      //系统名称
      "Platform": Platform.isIOS ? iosInfo?.systemName : "Android",
      "deviceType": iosInfo?.model,
      //是不是物理设备
      "isPhysicalDevice": Platform.isIOS
          ? iosInfo?.isPhysicalDevice
          : androidInfo?.isPhysicalDevice,
      "deviceName": androidInfo?.model,
      //用户唯一识别码
      "uuid":
      Platform.isIOS ? iosInfo?.identifierForVendor : androidInfo?.id,
      //手机具体的固件型号/Ui版本
      "version": androidInfo?.version.release,
      "incremental": Platform.isIOS
          ? iosInfo?.systemVersion
          : androidInfo?.version.incremental,
    };
    return data;
  }

  static Future<String> getChannel() async {
    // if (Platform.isAndroid) {
    //   const channel = MethodChannel('android_channel_info'); // 确保与原生端一致
    //   try {
    //     final String? result = await channel.invokeMethod('getChannel');
    //     var androidChannel = result ?? '';
    //     return androidChannel.isEmpty
    //         ? AppChannel.common.channel
    //         : androidChannel;
    //   } on PlatformException catch (e) {
    //     logPrint('Failed to get channel: ${e.message}');
    //     return AppChannel.common.channel;
    //   }
    // }
    return AppChannel.apple.channel;
  }

//  # 打包华为渠道
//  flutter build apk --flavor huawei --release --split-per-abi
  //flutter build appbundle --flavor huawei --release
//
//  # 打包小米渠道
//  flutter build apk --flavor xiaomi --release --split-per-abi
//
//  # 打包所有渠道
//  flutter build apk --flavor all --release --split-per-abi

//普通不分渠道
//flutter build apk --release --split-per-abi
// 推荐:
  //flutter build appbundle --release

  //flutter pub run build_runner build
}
