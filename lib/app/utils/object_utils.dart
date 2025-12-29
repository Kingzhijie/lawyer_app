import 'dart:convert' as convert;
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

import '../common/extension/string_extension.dart';

/// Object 工具类
class ObjectUtils {
  /// 判断对象是否为null
  static bool isNull(dynamic s) => s == null;

  static int toInt(dynamic s) => s.toString().toInt();

  static bool toBool(dynamic s) {
    if (s == null || s == 0) {
      return false;
    }
    if (s == 1) {
      return true;
    }
    if (s.toString().toLowerCase() == 'true' || s.toString().toLowerCase() == 'yes') {
      return true;
    }
    return false;
  }

  /// Checks if data is null or blank (empty or only contains whitespace).
  /// 检查数据是否为空或空(空或只包含空格)
  static bool isNullOrBlank(dynamic s) {
    if (isNull(s)) return true;
    switch (s.runtimeType) {
      case String:
      case List:
      case Map:
      case Set:
      case Iterable:
        return s.isEmpty;
        break;
      default:
        return s.toString() == 'null' || s.toString().trim().isEmpty;
    }
  }

  /// Returns true if the string is null or 0-length.
  /// 判断字符串是否为空
  static bool isEmptyString(String? str) {
    return str == null || str.isEmpty || str == 'null';
  }

  /// Returns true if the string is null or 0-length.
  /// 判断是否为空
  static bool isEmptyNum(num? value) {
    return value == null || value == 0;
  }

  /// 判断bool值
  static bool boolValue(bool? b) {
    if (b != null) {
      return b;
    }
    return false;
  }

  /// Returns true if the list is null or 0-length.
  /// 判断集合是否为空
  static bool isEmptyList(Iterable? list) {
    return list == null || list.isEmpty;
  }

  /// Returns true if there is no key/value pair in the map.
  /// 判断字典是否为空
  static bool isEmptyMap(Map? map) {
    return map == null || map.isEmpty;
  }

  /// Returns true  String or List or Map is empty.
  /// 判断object对象是否为空
  static bool isEmpty(Object? object) {
    if (object == null) return true;
    if (object is String && object.isEmpty) {
      return true;
    } else if (object is Iterable && object.isEmpty) {
      return true;
    } else if (object is Map && object.isEmpty) {
      return true;
    }
    return false;
  }

  /// Returns true String or List or Map is not empty.
  /// 判断object是否不为空
  static bool isNotEmpty(Object object) {
    return !isEmpty(object);
  }

  /// Returns true Two List Is Equal.
  /// 比较两个集合是否相同
  static bool compareListIsEqual(List? listA, List? listB) {
    if (listA == listB) return true;
    if (listA == null || listB == null) return false;
    int length = listA.length;
    if (length != listB.length) return false;
    for (int i = 0; i < length; i++) {
      if (!listA.contains(listB[i])) {
        return false;
      }
    }
    return true;
  }

  /// get length.
  /// 获取object的长度
  static int getLength(Object? value) {
    if (value == null) return 0;
    if (value is String) {
      return value.length;
    } else if (value is Iterable) {
      return value.length;
    } else if (value is Map) {
      return value.length;
    } else {
      return 0;
    }
  }

  /**
   * 将url参数转换成map
   */
  static Map<String, dynamic> getUrlParams(String param) {
    Map<String, Object> map = {};
    if (param.isEmpty) {
      return map;
    }
    List<String> params = param.split('?').last.split("&");
    for (int i = 0; i < params.length; i++) {
      List<String> p = params[i].split("=");
      if (p.length == 2) {
        map[p[0]] = p[1];
      }
    }
    return map;
  }

  /**
   * 将map转换成url
   * ignoreKey: 忽略key
   */
  static String getUrlParamsByMap(Map<String, dynamic> map,
      {String ignoreKey = ''}) {
    if (map.isEmpty) {
      return "";
    }
    String sb = '';
    map.forEach((key, value) {
      if (key != ignoreKey) {
        if (sb.isEmpty) {
          sb = '$key=$value';
        } else {
          sb = sb + '&$key=$value';
        }
      }
    });
    return sb;
  }

  /// 获取count位随机数
  static int getRandom(int count) {
    Random r = Random.secure();
    return r.nextInt(pow(10, count).toInt());
  }

  /// json转字符串
  static String jsonToStr(Map<String, dynamic> map) {
    return convert.jsonEncode(map);
  }

  /// 字符串转对象
  static dynamic strToObject(String str) {
    return convert.jsonDecode(str);
  }

  /// map比对是否相同
  static bool mapEquals<T, U>(Map<T, U>? a, Map<T, U>? b) {
    if (a == null) {
      return b == null;
    }
    if (b == null || a.length != b.length) {
      return false;
    }
    if (identical(a, b)) {
      return true;
    }
    for (final T key in a.keys) {
      if (!b.containsKey(key) || b[key].toString() != a[key].toString()) {
        return false;
      }
    }
    return true;
  }

  static bool isImage(String url) {
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp', '.HEIC'];
    return imageExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }

  static bool isVideo(String url) {
    final videoExtensions = ['.mp4', '.mov', '.avi', '.webm', '.mkv', '.flv'];
    return videoExtensions.any((ext) => url.toLowerCase().endsWith(ext));
  }

  /// 自动去除末尾的0
  static String removeTrailingZeros(double? number) {
    if (number == null) {
      return '';
    }
    return NumberFormat.decimalPattern().format(number);
  }

  static Future<Uint8List> compressImage(Uint8List imageData, int quality,
      {CompressFormat? format, int? minWidth, int? minHeight}) async {
    return await FlutterImageCompress.compressWithList(imageData,
        minHeight: minHeight ?? 1080,
        minWidth: minWidth ?? 1080,
        quality: quality,
        format: format ?? CompressFormat.jpeg);
  }

  static bool isAppStoreLink(String? url) {
    if (url == null) {
      return false;
    }
    final uri = Uri.parse(url);

    if (Platform.isIOS) {
      return true;
    }

    final List<String> marketSchemes = [
      'appmarket',  //荣耀华为
      'mimarket',//小米
      'vivomarket', //vivo
      'oppomarket', //oppo
      'mzstore' //魅族
    ];

    if (marketSchemes.contains(uri.scheme)) {
      return true;
    }

    if (url.startsWith('http')) {
      return true;
    }

    return false;
  }

  static Future<void> launchAppStore(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // 强制外部打开
      );
    } else {
      showToast('请打开应用市场搜索更新应用');
    }
  }

  static int? toPixelRatioInt(num? value) {
    if (value == null) {
      return null;
    }
    if (value == double.infinity) {
      return null;
    }
    return (value * (AppScreenUtil.pixelRatio ?? 1)).toInt();
  }

  static List<T> getRandomElements<T>(List<T> list, int count) {
    if (list.length <= count) return List.from(list);
    final random = Random();
    final result = <T>{};

    while (result.length < count) {
      result.add(list[random.nextInt(list.length)]);
    }
    return result.toList();
  }

}

/// 延迟 duration 毫秒
void delay(int duration, Function function) async {
  await Future.delayed(Duration(milliseconds: duration), () {
    function();
  });
}

///查找控制器
T? getFindController<T>({String? tag}) {
  //Get.isRegistered<MyPageController>()
  try {
    return Get.find<T>(tag: tag);
  } catch (_) {
    return null;
  }
}
