import 'dart:io';

import '../utils/device_info_utils.dart';

enum Env { test, dev, product }

class DioConfig {
  /// 环境配置
  static const Env env = Env.test;

  ///项目api基地址
  static String get baseURL {
    switch (DioConfig.env) {
      case Env.test:
        // return 'http://192.168.101.225:9000';
        return 'http://101.37.88.57/app-api';
      case Env.dev:
        return 'https://api.miliyue.com';
      case Env.product:
        return 'https://api.miliyue.com';
    }
  }

  ///项目H5基地址 - 待确认修改
  static String get baseWebURL {
    switch (DioConfig.env) {
      case Env.test:
        return 'https://banban-1oh.pages.dev/bbl/';
      case Env.dev:
        return 'https://banban-1oh.pages.dev/bbl/';
      case Env.product:
        return 'https://banban-1oh.pages.dev/bbl/';
    }
  }

  /// 网络连接超时时间
  static const connectTimeout = Duration(seconds: 15);

  /// 网络数据接受超时时间
  static const receiveTimeout = Duration(seconds: 15);

  /// 发送超时时间
  static const sendTimeout = Duration(seconds: 15);

  /// 自定义Header
  static Map<String, dynamic> httpHeaders = {
    "Accept": "application/json, text/plain, */*",
    'Content-Type': 'application/json',
    "app_version": DeviceInfo.version,
    "app_build": DeviceInfo.buildNumber,
    "device": Platform.operatingSystem,
    'systemVersion': DeviceInfo.deviceSystemVersion
  };

}
