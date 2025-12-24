import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储的公共key
class StorageKey {
  ///用户token
  static String get accessToken => 'accessToken';

  ///是否首次安装
  static String get isFirstInstall => 'isFirstInstallApp';

  ///本地设置语言
  static String get languageCode => 'languageCode';

  ///青少年模式
  static String get teenageModeKey => 'teenageMode';
}

class StorageUtils {
  /// 数据持久化
  static SharedPreferences? instance;

  static Future<void> initSharedPreferences() async {
    instance = await SharedPreferences.getInstance();
  }

  /*数据存储*/
  static void setInt(String key, int value) {
    instance?.setInt(key, value);
  }

  /*数据存储*/
  static void setBool(String key, bool value) {
    instance?.setBool(key, value);
  }

  // 字符串存储
  static void setString(String key, String value) {
    instance?.setString(key, value);
  }

  // 字符串数组存储
  static void setStringList(String key, List<String> value) {
    instance?.setStringList(key, value);
  }

  // 字符串数组存储
  static List<String>? getStringList(String key) {
    return instance?.getStringList(key);
  }

  /// 数据读取 返回泛型
  static Object? get<T>(String key) {
    return instance?.get(key);
  }

  /// 数据读取
  static String? getString<T>(String key) {
    return instance?.getString(key);
  }

  // 字符串移除
  static void removeString(String key) {
    instance?.remove(key);
  }

  static void setToken(String token) {
    StorageUtils.setString(StorageKey.accessToken, token);
  }

  static String getToken() {
    return StorageUtils.getString(StorageKey.accessToken) ?? '';
  }

  /// 获取是否首次安装
  static String getIsFirstInstall() {
    return StorageUtils.getString(StorageKey.isFirstInstall) ?? '';
  }

  /// 记录安装
  static void setIsFirstInstall() {
    return StorageUtils.setString(StorageKey.isFirstInstall, 'install');
  }

}
