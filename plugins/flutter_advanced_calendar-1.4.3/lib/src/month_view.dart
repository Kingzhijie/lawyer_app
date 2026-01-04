part of 'widget.dart';

class MonthView extends StatelessWidget {
  const MonthView({
    Key? key,
    required this.monthView,
    required this.todayDate,
    required this.selectedDate,
    required this.weekLineHeight,
    required this.weeksAmount,
    required this.innerDot,
    this.onChanged,
    this.events,
    required this.keepLineSize,
    this.textStyle,
  }) : super(key: key);

  final ViewRange monthView;
  final DateTime? todayDate;
  final DateTime selectedDate;
  final double weekLineHeight;
  final int weeksAmount;
  final ValueChanged<DateTime>? onChanged;
  final List<DateTime>? events;
  final bool innerDot;
  final bool keepLineSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final index = selectedDate.findWeekIndex(monthView.dates);

    // 计算实际需要的周数：找到最后一个属于当前月份的日期
    int actualWeeksNeeded = weeksAmount;
    for (int weekIndex = weeksAmount - 1; weekIndex >= 0; weekIndex--) {
      final weekStart = weekIndex * 7;
      final weekDates = monthView.dates.sublist(weekStart, weekStart + 7);

      // 检查这一周是否有任何日期属于当前月份
      final hasCurrentMonthDate =
          weekDates.any((date) => date.month == monthView.firstDay.month);

      if (hasCurrentMonthDate) {
        actualWeeksNeeded = weekIndex + 1;
        break;
      }
    }

    final offset = index / (weeksAmount - 1) * 2 - 1.0;
    return OverflowBox(
      alignment: Alignment(0, offset),
      minHeight: weekLineHeight,
      maxHeight: weekLineHeight * weeksAmount,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          actualWeeksNeeded,
          (weekIndex) {
            final weekStart = weekIndex * 7;

            return WeekView(
              innerDot: innerDot,
              dates: monthView.dates.sublist(weekStart, weekStart + 7),
              selectedDate: selectedDate,
              highlightMonth: monthView.firstDay.month,
              lineHeight: weekLineHeight,
              onChanged: onChanged,
              events: events,
              keepLineSize: keepLineSize,
              textStyle: textStyle,
            );
          },
          growable: false,
        ),
      ),
    );
  }
}
