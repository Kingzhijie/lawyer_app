extension DateTimeUtil on DateTime {
  /// Generate a new DateTime instance with a zero time.
  DateTime toZeroTime() => DateTime.utc(year, month, day, 12);

  int findWeekIndex(List<DateTime> dates) {
    return dates.indexWhere(isAtSameMomentAs) ~/ 7;
  }

  /// Calculates first week date from this date based on startWeekDay.
  /// startWeekDay: 0 = Sunday, 1 = Monday, ..., 6 = Saturday
  DateTime firstDayOfWeek({int? startWeekDay}) {
    final utcDate = DateTime.utc(year, month, day, 12);
    if (startWeekDay != null && startWeekDay < 7) {
      // DateTime.weekday: 1 = Monday, 2 = Tuesday, ..., 7 = Sunday
      // 转换为 0-6 的索引：0 = Monday, 1 = Tuesday, ..., 6 = Sunday
      final currentDayIndex = utcDate.weekday % 7; // 周一=1, 周日=0

      // 计算需要回退的天数
      int daysToSubtract = (currentDayIndex - startWeekDay) % 7;
      if (daysToSubtract < 0) {
        daysToSubtract += 7;
      }

      return utcDate.subtract(Duration(days: daysToSubtract));
    }
    // 默认：周日开始
    return utcDate.subtract(Duration(days: utcDate.weekday % 7));
  }

  /// Generates 7 dates according to this date.
  /// (Supposed that this date is result of [firstDayOfWeek])
  List<DateTime> weekDates() {
    return List.generate(
      7,
      (index) => add(Duration(days: index)),
      growable: false,
    );
  }

  /// Generates list of list with [DateTime]
  /// according to [date] and [weeksAmount].
  /// gives the beginning of the day of the week [startWeekDay]
  List<List<DateTime>> generateWeeks(int weeksAmount, {int? startWeekDay}) {
    final firstViewDate = firstDayOfWeek(startWeekDay: startWeekDay).subtract(
      Duration(
        days: (weeksAmount ~/ 2) * 7,
      ),
    );

    return List.generate(
      weeksAmount,
      (weekIndex) {
        final firstDateOfNextWeek = firstViewDate.add(
          Duration(
            days: weekIndex * 7,
          ),
        );

        return firstDateOfNextWeek.weekDates();
      },
      growable: false,
    );
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
