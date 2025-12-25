part of 'widget.dart';

class WeekView extends StatelessWidget {
  WeekView({
    Key? key,
    required this.dates,
    required this.selectedDate,
    required this.lineHeight,
    this.highlightMonth,
    this.onChanged,
    this.events,
    required this.innerDot,
    required this.keepLineSize,
    this.textStyle,
  }) : super(key: key);

  final DateTime todayDate = DateTime.now().toZeroTime();
  final List<DateTime> dates;
  final double lineHeight;
  final int? highlightMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime>? onChanged;
  final List<DateTime>? events;
  final bool innerDot;
  final bool keepLineSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: lineHeight,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List<Widget>.generate(
          7,
          (dayIndex) {
            final date = dates[dayIndex];
            final isToday = date.isAtSameMomentAs(todayDate);
            final isSelected = date.isAtSameMomentAs(selectedDate);
            final isHighlight = highlightMonth == date.month;

            final hasEvent =
                events!.indexWhere((element) => element.isSameDate(date));

            if (keepLineSize) {
              return InkResponse(
                onTap: onChanged != null ? () => onChanged!(date) : null,
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.primaryColor
                        : isToday
                            ? theme.highlightColor
                            : null,
                    borderRadius: BorderRadius.circular(50),
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    children: [
                      Text(
                        isToday ? '今' : '${date.day}',
                        style: textStyle?.copyWith(
                          color: isSelected || isToday
                              ? theme.colorScheme.onPrimary
                              : isHighlight || highlightMonth == null
                                  ? null
                                  : theme.disabledColor,
                          fontWeight:
                              isSelected && textStyle?.fontWeight != null
                                  ? FontWeight
                                      .values[textStyle!.fontWeight!.index + 2]
                                  : textStyle?.fontWeight,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DateBox(
                  width: lineHeight,
                  height: lineHeight,
                  showDot: innerDot,
                  onPressed: onChanged != null ? () => onChanged!(date) : null,
                  isSelected: isSelected,
                  isToday: isToday,
                  hasEvent: !hasEvent.isNegative,
                  child: Text(
                    isToday ? '今' : '${date.day}',
                    maxLines: 1,
                    style: textStyle?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : isHighlight || highlightMonth == null
                              ? textStyle?.color
                              : theme.disabledColor,
                    ) ?? TextStyle(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : isHighlight || highlightMonth == null
                              ? null
                              : theme.disabledColor,
                    ),
                  ),
                ),
              ],
            );
          },
          growable: false,
        ),
      ),
    );
  }
}
