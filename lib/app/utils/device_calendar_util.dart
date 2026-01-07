import 'package:device_calendar/device_calendar.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
/// 设备日历工具类（支持静默添加，无需跳转系统日历）
class DeviceCalendarUtil {
  DeviceCalendarUtil._();

  static final DeviceCalendarPlugin _plugin = DeviceCalendarPlugin();
  static bool _tzInitialized = false;
  static String? _defaultCalendarId;

  /// 初始化时区数据（首次使用前调用）
  static void _initTimezone() {
    if (!_tzInitialized) {
      tz_data.initializeTimeZones();
      _tzInitialized = true;
    }
  }

  /// 请求日历权限
  static Future<bool> requestPermission() async {
    try {
      var permissionsGranted = await _plugin.hasPermissions();
      if (permissionsGranted.isSuccess && (permissionsGranted.data ?? false)) {
        return true;
      }

      var result = await _plugin.requestPermissions();
      return result.isSuccess && (result.data ?? false);
    } catch (e) {
      logPrint('❌ 请求日历权限失败: $e');
      return false;
    }
  }

  /// 获取所有日历
  static Future<List<Calendar>> getCalendars() async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) return [];

      final result = await _plugin.retrieveCalendars();
      if (result.isSuccess && result.data != null) {
        return result.data!;
      }
      return [];
    } catch (e) {
      logPrint('❌ 获取日历列表失败: $e');
      return [];
    }
  }

  /// 获取默认日历ID（优先选择可写入的主日历）
  static Future<String?> getDefaultCalendarId() async {
    if (_defaultCalendarId != null) return _defaultCalendarId;

    final calendars = await getCalendars();
    if (calendars.isEmpty) return null;

    // 优先选择默认日历或第一个可写入的日历
    for (var calendar in calendars) {
      if (calendar.isDefault == true && calendar.isReadOnly == false) {
        _defaultCalendarId = calendar.id;
        return _defaultCalendarId;
      }
    }

    // 没有默认日历，选择第一个可写入的
    for (var calendar in calendars) {
      if (calendar.isReadOnly == false) {
        _defaultCalendarId = calendar.id;
        return _defaultCalendarId;
      }
    }

    return calendars.first.id;
  }

  /// 静默添加日历事件（不跳转系统日历）
  ///
  /// [title] 事件标题（必填）
  /// [startDate] 开始时间（必填）
  /// [endDate] 结束时间（可选，默认与开始时间相同）
  /// [description] 事件描述
  /// [location] 事件地点
  /// [reminderMinutes] 提前提醒分钟数（如 30 表示提前30分钟提醒）
  /// [allDay] 是否全天事件
  /// [calendarId] 指定日历ID（可选，默认使用系统默认日历）
  ///
  /// 返回事件ID，失败返回null
  static Future<String?> addEvent({
    required String title,
    required DateTime startDate,
    DateTime? endDate,
    String? description,
    String? location,
    int? reminderMinutes,
    bool allDay = false,
    String? calendarId,
  }) async {
    try {
      _initTimezone();

      final hasPermission = await requestPermission();
      if (!hasPermission) {
        logPrint('❌ 没有日历权限');
        return null;
      }

      final targetCalendarId = calendarId ?? await getDefaultCalendarId();
      if (targetCalendarId == null) {
        logPrint('❌ 没有可用的日历');
        return null;
      }

      final event = Event(
        targetCalendarId,
        title: title,
        description: description,
        location: location,
        start: tz.TZDateTime.from(startDate, tz.local),
        end: tz.TZDateTime.from(endDate ?? startDate, tz.local),
        allDay: allDay,
      );

      // 添加提醒
      if (reminderMinutes != null && reminderMinutes > 0) {
        event.reminders = [Reminder(minutes: reminderMinutes)];
      }

      final result = await _plugin.createOrUpdateEvent(event);
      if (result?.isSuccess == true && result?.data != null) {
        logPrint('✅ 日历事件添加成功: $title, ID: ${result!.data}');
        return result.data;
      } else {
        logPrint('❌ 日历事件添加失败: ${result?.errors}');
        return null;
      }
    } catch (e) {
      logPrint('❌ 添加日历事件异常: $e');
      return null;
    }
  }

  /// 静默添加简单提醒
  ///
  /// [title] 提醒标题
  /// [dateTime] 提醒时间
  /// [description] 提醒描述
  /// [reminderMinutes] 提前多少分钟提醒（默认30分钟）
  static Future<String?> addReminder({
    required String title,
    required DateTime dateTime,
    String? description,
    int reminderMinutes = 30,
  }) async {
    return addEvent(
      title: title,
      startDate: dateTime,
      endDate: dateTime,
      description: description,
      reminderMinutes: reminderMinutes,
    );
  }

  /// 删除日历事件
  /// 
  /// [eventId] 事件ID（添加时返回的ID）
  /// [calendarId] 日历ID（可选，默认使用系统默认日历）
  static Future<bool> deleteEvent({
    required String eventId,
    String? calendarId,
  }) async {
    try {
      final targetCalendarId = calendarId ?? await getDefaultCalendarId();
      if (targetCalendarId == null) {
        logPrint('❌ 没有可用的日历');
        return false;
      }

      final result = await _plugin.deleteEvent(targetCalendarId, eventId);
      if (result.isSuccess && (result.data ?? false)) {
        logPrint('✅ 日历事件删除成功: $eventId');
        return true;
      }
      logPrint('❌ 日历事件删除失败: $result');
      return false;
    } catch (e) {
      logPrint('❌ 删除日历事件失败: $e');
      return false;
    }
  }

  /// 查询日历事件
  static Future<List<Event>> getEvents({
    required DateTime startDate,
    required DateTime endDate,
    String? calendarId,
  }) async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) return [];

      final targetCalendarId = calendarId ?? await getDefaultCalendarId();
      if (targetCalendarId == null) return [];

      final result = await _plugin.retrieveEvents(
        targetCalendarId,
        RetrieveEventsParams(startDate: startDate, endDate: endDate),
      );

      if (result.isSuccess && result.data != null) {
        return result.data!;
      }
      return [];
    } catch (e) {
      logPrint('❌ 查询日历事件失败: $e');
      return [];
    }
  }
}
