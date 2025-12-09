/// @Autor:hpp
/// @Date: 2023-11-02
/// @Description: 字符串相关扩展方法

// ignore: depend_on_referenced_packages
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/object_utils.dart';
import '../../utils/screen_utils.dart';



extension StringOssExtension on String {
  /// 指定宽度图片地址
  String? ossProcessWidth(double width, {int quality = 100}) {
    if (contains('.gif') || isEmpty || this == null) {
      return this;
    }
    if (contains('x-oss-process')) {
      //已压缩处理过的图片
      return this;
    }
    int newWidth = (width * (AppScreenUtil.pixelRatio ?? 0)).toInt();
    String part = '?';
    if (contains('?')) {
      part = '&';
    }
    return '$this${part}x-oss-process=image/resize,w_$newWidth/format,webp/quality,q_$quality';
  }

  /// 指定宽度图片地址
  String ossProcessOriginalImage({String format = 'jpg'}) {
    if (contains('.gif') || isEmpty || this == null || ObjectUtils.isVideo(this)) {
      return this;
    }
    if (contains('x-oss-process')) {
      //已压缩处理过的图片
      return this;
    }
    String part = '?';
    if (contains('?')) {
      part = '&';
    }
    return '$this${part}x-oss-process=image/resize,w_1080/format,$format';
  }



  /// 原图
  String? ossOriginalImage() {
    if (contains('.gif') || isEmpty || this == null) {
      return this;
    }
    if (contains('x-oss-process')) {
      //已压缩处理过的图片
      return this;
    }
    String part = '?';
    if (contains('?')) {
      part = '&';
    }
    return '$this${part}x-oss-process=image/format,webp';
  }

}


///====================== 类型转换 ======================///



extension StringConvertExtension on String {
  int toInt() {
    if (ObjectUtils.isEmptyString(this) || this == 'null') {
      return 0;
    }
    return int.parse(replaceAll(',', ''));
  }

  int? toNullInt() {
    if (ObjectUtils.isEmptyString(this) || this == 'null') {
      return null;
    }
    return int.parse(replaceAll(',', ''));
  }

  double toDouble() {
    if (isEmpty) {
      return 0;
    }
    return double.parse(replaceAll(',', ''));
  }
}

///====================== 格式转换 ======================///

extension StringFormatExtension on String {
  /// 转化为带千位分隔符的金额样式
  String _toPrice() {
    var price = '';
    int end = length;
    if (contains('.')) {
      end = indexOf('.');
      price = substring(end);
      if (price.length > 3) {
        price = price.substring(0, 3);
      }
    }
    while (end - 3 > 0) {
      price = ',${substring(end - 3, end)}$price';
      end -= 3;
    }
    price = substring(0, end) + price;
    return price;
  }

  /// 转化为带千位分隔符的金额样式
  /// fractionDigits: 小数位数
  String toPrice({int? fractionDigits}) {
    if (!contains('.')) {
      return _toPrice();
    }
    if (fractionDigits != null) {
      return toDouble().toStringAsFixed(fractionDigits)._toPrice();
    } else {
      return Decimal.tryParse(this).toString()._toPrice();
    }
  }

  /// 转化为带千位分隔符的金额样式 多个￥
  String toRMBPrice({int? fractionDigits}) {
    return '￥${toPrice()}';
  }

  ///转化为万
  String toTenThousand({int? count}) {
    if (count != null) {
      if (count < 10000) {
        return count.toString();
      } else {
        return '${(count / 10000).toStringAsFixed(1)}W';
      }
    } else {
      return '0';
    }
  }

  ///转化为千和万
  String toThousandAndTenThousand({int? count}) {
    if (count != null) {
      if (count <= 999) {
        return count.toString();
      } else if (count < 10000 && count > 999) {
        return count.toString().toPrice();
      } else {
        return '${(count / 10000).toStringAsFixed(1)}w';
      }
    } else {
      return '0';
    }
  }

  /// 转化为三位一空、四位一空的手机号
  String toPhone() {
    if (length < 11) {
      return this;
    }
    return '${substring(0, 3)} ${substring(3, 7)} ${substring(7)}';
  }

  /// 转化为加密的手机号
  String toSecurityPhone() {
    if (length < 11) {
      return this;
    }
    return replaceRange(3, 7, '****');
  }

  /// 前边几位加****
  String toStartSecurity() {
    if (length < 3) {
      return this;
    }
    return replaceRange(0, length - 2, '****');
  }


  /// 获取视频封面图
  String getVideoCover(double width, {int quality = 80}){
    if (ObjectUtils.isVideo(this)) {
      var cover = '$this?x-oss-process=video/snapshot,t_1,f_jpg,w_750,m_fast';
      /// 阿里云oss的规则
      return cover;
    }
    if (width == 0) {
      return ossProcessOriginalImage();
    }
    return ossProcessWidth(width, quality: quality) ?? '';
  }

}

//防止英文或有特使字符换行被截断
extension FixAutoLines on String {
  String fixAutoLines() {
    return Characters(this).join('\u{200B}');
  }
}

///====================== 格式判断 ======================///

extension StringMatchExtension on String {
  /// 是否为手机号
  bool isPhone() {
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(12[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    return exp.hasMatch(this);
  }

  /// 是否为姓名
  bool isName() {
    RegExp exp = RegExp(r'^([\u4e00-\u9fa5_a-zA-Z]+$)');
    return exp.hasMatch(this);
  }

  /// 是否为密码 8-16位 数字+字母+特殊字符 两项必填
  bool isPassword() {
    RegExp exp = RegExp(
        r'^(?![0-9]+$)(?![a-zA-Z]+$)(?![~!@#$%^&*]+$)[0-9A-Za-z~!@#$%^&*]{8,16}$');
    return exp.hasMatch(this);
  }

  /// 是否为数字+字母
  /// [min] 最小长度
  /// [max] 最大长度
  bool isNumberAndLetter({required int min, required int max}) {
    RegExp exp = RegExp('^(?![0-9]+\$)(?![a-zA-Z]+\$)[0-9A-Za-z]{$min,$max}\$');
    return exp.hasMatch(this);
  }

  /// 是否为6位验证码
  bool isVerifyCode() {
    RegExp exp = RegExp(r'^\d{6}$');
    return exp.hasMatch(this);
  }

  /// 是否为身份证号
  bool isCardId() {
    if (length != 18) {
      return false;
    }
    RegExp postalCode = RegExp(
        r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|[Xx])$');
    if (!postalCode.hasMatch(this)) {
      return false;
    }
    //将前17位加权因子保存在数组里
    final List idCardList = [
      '7',
      '9',
      '10',
      '5',
      '8',
      '4',
      '2',
      '1',
      '6',
      '3',
      '7',
      '9',
      '10',
      '5',
      '8',
      '4',
      '2'
    ];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    final List idCardYArray = [
      '1',
      '0',
      '10',
      '9',
      '8',
      '7',
      '6',
      '5',
      '4',
      '3',
      '2'
    ];
    // 前17位各自乖以加权因子后的总和
    int idCardWiSum = 0;

    for (int i = 0; i < 17; i++) {
      int subStrIndex = int.parse(substring(i, i + 1));
      int idCardWiIndex = int.parse(idCardList[i]);
      idCardWiSum += subStrIndex * idCardWiIndex;
    }
    // 计算出校验码所在数组的位置
    int idCardMod = idCardWiSum % 11;
    // 得到最后一位号码
    String idCardLast = substring(17, 18);
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if (idCardMod == 2) {
      if (idCardLast != 'x' && idCardLast != 'X') {
        return false;
      }
    } else {
      //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
      if (idCardLast != idCardYArray[idCardMod]) {
        return false;
      }
    }
    return true;
  }

  /// 获取字符串中电话号码
  List<String> extractPhoneNumbers() {
    final pattern =
        RegExp("\\d{4}-\\d{8}|(\\+?86)?1[0-9]{10}", caseSensitive: false);
    Iterable<Match> matches = pattern.allMatches(this);
    List<String> phones = [];
    for (var element in matches) {
      if (!ObjectUtils.isEmptyString(element.group(0))) {
        phones.add(element.group(0)!);
      }
    }
    return phones;
  }
}

extension StringChangeExtension on String {
  ///数组转字符串
  static String getListStr(List list, {String split = ''}) {
    List tempList = [];
    String str = '';
    for (var f in list) {
      tempList.add(f);
    }

    for (var f in tempList) {
      if (str == '') {
        str = "$f";
      } else {
        str = "$str" "$split" "$f";
      }
    }

    return str;
  }

  static String mapToQueryParams(Map<String, dynamic> params) {
    return params.entries
        .where((entry) => entry.value != null)
        .map((entry) =>
            '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');
  }
}
