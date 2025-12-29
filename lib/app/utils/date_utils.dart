import 'package:intl/intl.dart';

class DateFormatUtils {
  ///毫秒转年月日时分秒
  static String milli2YMDHMS(int milliseconds) {
    if (milliseconds != 0) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      return '${zeroFill(time.year)}-${zeroFill(time.month)}-${zeroFill(time.day)} ${zeroFill(time.hour)}:${zeroFill(time.minute)}:${zeroFill(time.second)}';
    }
    return '';
  }

  ///毫秒转年月日时
  static String milli2YMDH(int milliseconds) {
    if (milliseconds != 0) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      return '${zeroFill(time.month)}-${zeroFill(time.day)} ${zeroFill(time.hour)}:00';
    }
    return '';
  }

  ///毫秒转年月日时分
  static String milli2YMDHM(int milliseconds) {
    if (milliseconds != 0) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      return '${zeroFill(time.year)}-${zeroFill(time.month)}-${zeroFill(time.day)} ${zeroFill(time.hour)}:${zeroFill(time.minute)}';
    }
    return '';
  }

  ///时分秒
  static String milli2HMS(int milliseconds) {
    if (milliseconds != 0) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      return '${zeroFill(time.hour)}:${zeroFill(time.minute)}:${zeroFill(time.second)}';
    }
    return '';
  }

  ///毫秒转年月日
  static String milli2YMD(int milliseconds) {
    if (milliseconds != 0) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      return '${zeroFill(time.year)}-${zeroFill(time.month)}-${zeroFill(time.day)}';
    }
    return '';
  }

  ///毫秒转年.月.日
  static String milli3YMD(int milliseconds) {
    if (milliseconds != 0) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      return '${zeroFill(time.year)}.${zeroFill(time.month)}.${zeroFill(time.day)}';
    }
    return '';
  }

  ///毫秒转年/月/日
  static String milli4YMD(int milliseconds) {
    if (milliseconds != 0) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(milliseconds);
      return '${zeroFill(time.year)}/${zeroFill(time.month)}/${zeroFill(time.day)}';
    }
    return '';
  }

  static String fromDate(DateTime time) {
    return '${time.year}-${DateFormatUtils.zeroFill(time.month)}-${DateFormatUtils.zeroFill(time.day)} ${DateFormatUtils.zeroFill(time.hour)}:${DateFormatUtils.zeroFill(time.minute)}:${DateFormatUtils.zeroFill(time.second)}';
  }

  static String zeroFill(int i) {
    return i >= 10 ? "$i" : "0$i";
  }

  /// 秒转时分秒
  static String second2HMS(int sec,
      {bool isEasy = true, bool isZeroFill = true}) {
    String hms = "00:00:00";
    if (!isEasy) hms = "00时00分00秒";
    if (sec > 0) {
      int h = sec ~/ 3600;
      int m = (sec % 3600) ~/ 60;
      int s = sec % 60;
      if (isZeroFill) {
        hms = "${zeroFill(h)}:${zeroFill(m)}:${zeroFill(s)}";
        if (!isEasy) hms = "${zeroFill(h)}时${zeroFill(m)}分${zeroFill(s)}秒";
      } else {
        var hStr = h == 0 ? '' : '${zeroFill(h)}${isEasy ? ':' : '时'}';
        hms = "$hStr${zeroFill(m)}:${zeroFill(s)}";
        if (!isEasy) hms = "$hStr${zeroFill(m)}分${zeroFill(s)}秒";
      }
    }
    return hms;
  }

  /// 秒转天时分秒
  static String second2DHMS(int sec) {
    String hms = "00天00时00分00秒";
    if (sec > 0) {
      int d = sec ~/ 86400;
      int h = (sec % 86400) ~/ 3600;
      int m = (sec % 3600) ~/ 60;
      int s = sec % 60;
      hms = "${zeroFill(d)}天${zeroFill(h)}时${zeroFill(m)}分${zeroFill(s)}秒";
    }
    return hms;
  }

  static List<int> second2DHMSList(int sec) {
    List<int> result = [];
    if (sec > 0) {
      int d = sec ~/ 86400;
      int h = (sec % 86400) ~/ 3600;
      int m = (sec % 3600) ~/ 60;
      int s = sec % 60;
      result.add(d);
      result.add(h);
      result.add(m);
      result.add(s);
    }
    return result;
  }

  ///秒转天时分
  static String second2DHM(int sec) {
    String hms = "00天00时00分00秒";
    if (sec > 0) {
      int d = sec ~/ 86400;
      int h = (sec % 86400) ~/ 3600;
      int m = (sec % 3600) ~/ 60;
      hms = "$d天${zeroFill(h)}时${zeroFill(m)}分";
    }
    return hms;
  }

  ///秒转天时分秒
  static String second2DHMSS(int sec) {
    String hms = "00天00时00分00秒";
    if (sec > 0) {
      int d = sec ~/ 86400;
      int h = (sec % 86400) ~/ 3600;
      int m = (sec % 3600) ~/ 60;
      int s = sec % 60;
      hms = "$d天${zeroFill(h)}时${zeroFill(m)}分${zeroFill(s)}秒";
    }
    return hms;
  }

  /// 秒转年月日天时分秒
  static String second2YMDHMS(int sec, {String format = '-'}) {
    String ydmhms = " ";
    if (sec <= 0) {
      return ydmhms;
    }
    if (sec < 1000000000000 && sec > 1000000000) {
      sec = sec * 1000;
    }

    DateTime createTime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(sec.toString()));
    ydmhms = createTime.toLocal().toString().substring(0, 19);
    ydmhms = ydmhms.replaceAll('-', format);
    return ydmhms;
  }

  /// 秒转天时分秒
  /// 补零列表长度4，0-日(00) 1-时(00) 2-分(00) 3-秒(00)
  static List<String> second2ListStr(int sec) {
    List<String> list = [];
    if (sec > 0) {
      list[0] = zeroFill(sec ~/ 86400); //日
      list[1] = zeroFill((sec % 86400) ~/ 3600); //时
      list[2] = zeroFill((sec % 3600) ~/ 60); //分
      list[3] = zeroFill(sec % 60); //秒
    } else {
      for (int i = 0; i < list.length; i++) {
        list[i] = "00";
      }
    }
    return list;
  }

  /// 秒转天时分秒
  /// 列表长度4，0-日 1-时 2-分 3-秒
  static List<int> second2List(int sec) {
    List<int> list = [];
    if (sec > 0) {
      list[0] = sec ~/ 86400; //日
      list[1] = (sec % 86400) ~/ 3600; //时
      list[2] = (sec % 3600) ~/ 60; //分
      list[3] = sec % 60; //秒
    } else {
      for (int i = 0; i < list.length; i++) {
        list[i] = 0;
      }
    }
    return list;
  }

  //获取时间
  static String getTimeStr(String? timeStr) {
    String dateTime = '';
    if (timeStr != null && timeStr.isNotEmpty) {
      DateTime postTime = DateTime.parse(timeStr);
      Duration diff = DateTime.now().difference(postTime);
      String month = zeroFill(postTime.month);
      String day = zeroFill(postTime.day);
      String hour = zeroFill(postTime.hour);
      String minute = zeroFill(postTime.minute);
      if (timeStr.isNotEmpty) {
        if (diff.inSeconds < 60) {
          dateTime = '刚刚';
        } else if (diff.inSeconds >= 60 && diff.inMinutes < 60) {
          dateTime = '${diff.inMinutes}分钟前';
        } else if (diff.inHours >= 1 && diff.inHours < 12) {
          dateTime = '${diff.inHours}小时前';
        } else if (postTime.isToday()) {
          dateTime = '$hour:$minute';
        } else if (postTime.isYear()) {
          dateTime = '$month-$day $hour:$minute';
        } else {
          dateTime = '${postTime.year}-$month-$day $hour:$minute';
        }
      }
    }
    return dateTime;
  }


  ///获取通知时间
  static String getNotificationTimeStr(int milliseconds, {bool? isFirst}) {
    String dateTime = '';
    if (milliseconds == 0) {
      return dateTime;
    }
    if (milliseconds.toString().length == 10) { ///如果是秒转毫秒
      milliseconds = milliseconds * 1000;
    }
    DateTime postTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    Duration diff = DateTime.now().difference(postTime);
    String month =
        postTime.month < 10 ? '0${postTime.month}' : '${postTime.month}';
    String day = postTime.day < 10 ? '0${postTime.day}' : '${postTime.day}';
    String hour = postTime.hour < 10 ? '0${postTime.hour}' : '${postTime.hour}';
    String minute =
        postTime.minute < 10 ? '0${postTime.minute}' : '${postTime.minute}';
    //String second = postTime.second < 10 ? '0${postTime.second}' : '${postTime.second}';
    if (isFirst == true) {
      if (diff.inSeconds < 60) {
        dateTime = '刚刚';
      } else if (diff.inSeconds >= 60 && diff.inMinutes < 60) {
        dateTime = '${diff.inMinutes}分钟前';
      } else if (diff.inMinutes >= 60 && postTime.isToday()) {
        dateTime = '$hour:$minute';
      } else if (postTime.isYear()) {
        dateTime = '$month-$day $hour:$minute';
      } else {
        dateTime = '${postTime.year}-$month-$day $hour:$minute';
      }
    } else {
      if (diff.inSeconds < 60) {
        dateTime = '刚刚';
      } else if (diff.inSeconds >= 60 && postTime.isToday()) {
        dateTime = '$hour:$minute';
      } else {
        dateTime = '${postTime.year}-$month-$day $hour:$minute';
      }
    }
    return dateTime;
  }

  ///时间字符串转特定格式的时间字符串
  static String getAppointTime(
      {required String dateStr, required String format}) {
    DateTime dateTime = DateTime.parse(dateStr);
    String appointTime = DateFormat(format).format(dateTime);
    return appointTime;
  }


}

class DateTimeUtils {
  /// 从UTC时间戳转为时间
  static DateTime fromUtcMillisecondsSinceEpoch(int millisecondsSinceEpoch) {
    String timeZ =
        '${DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch)}Z';
    return DateTime.parse(timeZ).toLocal();
  }

  /// 从UTC时间戳字符串转为时间
  static DateTime fromUtcMillisecondsStringSinceEpoch(String millisecondsString,
      {bool isUtc = false}) {
    return fromUtcMillisecondsSinceEpoch(int.parse(millisecondsString));
  }

  ///yyyy-MM-DD转DateTime
  static DateTime format(String data, {String format = "yyyy-MM-DD"}) {
    // if (data.isNotEmpty) {
    //   return DateFormat(format).parse(data);
    // } else {
    //   return null;
    // }
    return DateFormat(format).parse(data);
  }

  ///获取当前日期返回DateTime
  static DateTime getNowDateTime() {
    return DateTime.now();
  }

  ///格式化时间戳
  ///time:毫秒值
  ///format:"yyyy年MM月dd hh:mm:ss"  "yyy?MM?dd  hh?MM?dd" "yyyy:MM:dd"......
  ///结果： 2019?08?04  02?08?02
  static getFormatData({required int time, required String format}) {
    var dataFormat = DateFormat(format);
    var dateTime = DateTime.fromMillisecondsSinceEpoch(time);
    String formatResult = dataFormat.format(dateTime);
    return formatResult;
  }

  // 获取星期
  static String getWeek(DateTime date) {
    var week = date.weekday;
    String w = '';
    switch (week.toString()) {
      case '1':
        w = '一';
        break;
      case '2':
        w = '二';
        break;
      case '3':
        w = '三';
        break;
      case '4':
        w = '四';
        break;
      case '5':
        w = '五';
        break;
      case '6':
        w = '六';
        break;
      case '7':
        w = '日';
        break;
    }
    return '周$w';
  }
}

extension DateTimeExtensions on DateTime {
  bool isToday() {
    final DateTime now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isYear() {
    final DateTime now = DateTime.now();
    return year == now.year;
  }
}
