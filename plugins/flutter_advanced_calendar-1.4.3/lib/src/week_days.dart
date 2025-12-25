part of 'widget.dart';

/// Week day names line.
class WeekDays extends StatelessWidget {
  const WeekDays({
    Key? key,
    this.weekNames = const <String>['日', '一', '二', '三', '四', '五', '六'],
    this.style,
    required this.keepLineSize,
  })  : assert(weekNames.length == 7, '`weekNames` must have length 7'),
        super(key: key);

  /// Week day names.
  final List<String> weekNames;

  /// Text style.
  final TextStyle? style;

  final bool keepLineSize;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyle(
      fontSize: 14,
      color: const Color(0x42000000),
    );
    return DefaultTextStyle(
      style: style ?? defaultStyle,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(weekNames.length, (index) {
          return DateBox(
            child: Text(weekNames[index]),
            isHeader: true,
          );
        }),
      ),
    );
  }
}
