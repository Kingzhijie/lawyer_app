import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'controller.dart';
import 'datetime_util.dart';

part 'date_box.dart';
part 'handlebar.dart';
part 'header.dart';
part 'month_view.dart';
part 'month_view_bean.dart';
part 'week_days.dart';
part 'week_view.dart';

/// 自定义的更灵敏的 PageView 滚动物理效果
class SensitivePageScrollPhysics extends PageScrollPhysics {
  const SensitivePageScrollPhysics({super.parent});

  @override
  SensitivePageScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SensitivePageScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 50.0; // 降低最小滑动速度阈值（默认是 50）

  @override
  double get minFlingDistance => 15.0; // 降低最小滑动距离阈值（默认是 50）
}

/// Advanced Calendar widget.
class AdvancedCalendar extends StatefulWidget {
  const AdvancedCalendar({
    Key? key,
    this.controller,
    this.startWeekDay,
    this.events,
    this.weekLineHeight = 32.0,
    this.preloadMonthViewAmount = 13,
    this.preloadWeekViewAmount = 21,
    this.weeksInMonthViewAmount = 6,
    this.todayStyle,
    this.headerStyle,
    this.onHorizontalDrag,
    this.innerDot = false,
    this.keepLineSize = false,
    this.calendarTextStyle,
    this.showNavigationArrows = false,
  })  : assert(
          keepLineSize && innerDot ||
              innerDot && !keepLineSize ||
              !innerDot && !keepLineSize,
          'keepLineSize should be used only when innerDot is true',
        ),
        super(key: key);

  /// Calendar selection date controller.
  final AdvancedCalendarController? controller;

  /// Executes on horizontal calendar swipe. Allows to load additional dates.
  final Function(DateTime)? onHorizontalDrag;

  /// Height of week line.
  final double weekLineHeight;

  /// Amount of months in month view to preload.
  final int preloadMonthViewAmount;

  /// Amount of weeks in week view to preload.
  final int preloadWeekViewAmount;

  /// Weeks lines amount in month view.
  final int weeksInMonthViewAmount;

  /// List of points for the week and month
  final List<DateTime>? events;

  /// The first day of the week starts[0-6]
  final int? startWeekDay;

  /// Style of headers date
  final TextStyle? headerStyle;

  /// Style of Today button
  final TextStyle? todayStyle;

  /// Show DateBox event in container.
  final bool innerDot;

  /// Keeps consistent line size for dates
  /// Can't be used without innerDot
  final bool keepLineSize;

  /// Text style for dates in calendar
  final TextStyle? calendarTextStyle;

  /// Show navigation arrows.
  final bool showNavigationArrows;

  @override
  _AdvancedCalendarState createState() => _AdvancedCalendarState();
}

class _AdvancedCalendarState extends State<AdvancedCalendar>
    with SingleTickerProviderStateMixin {
  late ValueNotifier<int> _monthViewCurrentPage;
  late AnimationController _animationController;
  late AdvancedCalendarController _controller;
  late double _animationValue;
  late List<ViewRange> _monthRangeList;
  late List<List<DateTime>> _weekRangeList;

  PageController? _monthPageController;
  PageController? _weekPageController;
  Offset? _captureOffset;
  DateTime? _todayDate;
  List<String>? _weekNames;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? AdvancedCalendarController.today();
    _todayDate = _controller.value;

    final monthPageIndex = widget.preloadMonthViewAmount ~/ 2;

    _monthViewCurrentPage = ValueNotifier(monthPageIndex);

    _monthPageController = PageController(
      initialPage: monthPageIndex,
    );

    final weekPageIndex = widget.preloadWeekViewAmount ~/ 2;

    _weekPageController = PageController(
      initialPage: weekPageIndex,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0, // 初始为收起状态（周视图）
    );

    _animationValue = _animationController.value;

    _monthRangeList = List.generate(
      widget.preloadMonthViewAmount,
      (index) => ViewRange.generateDates(
        _todayDate!,
        _todayDate!.month + (index - monthPageIndex),
        widget.weeksInMonthViewAmount,
        startWeekDay: widget.startWeekDay,
      ),
    );

    // 使用今天的日期生成周视图列表，确保中间页是今天所在的周
    _weekRangeList = _todayDate!.generateWeeks(
      widget.preloadWeekViewAmount,
      startWeekDay: widget.startWeekDay,
    );
    _controller.addListener(() {
      // 只在展开状态时才更新周视图并跳转
      if (_animationController.value >= 0.5) {
        _weekRangeList = _controller.value.generateWeeks(
          widget.preloadWeekViewAmount,
          startWeekDay: widget.startWeekDay,
        );
        _weekPageController!.jumpToPage(widget.preloadWeekViewAmount ~/ 2);
      }
    });
    if (widget.startWeekDay != null && widget.startWeekDay! < 7) {
      // 使用中文星期标签
      _weekNames = const <String>['日', '一', '二', '三', '四', '五', '六'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: DefaultTextStyle.merge(
        style: theme.textTheme.bodyMedium,
        child: GestureDetector(
          onVerticalDragStart: (details) {
            _captureOffset = details.globalPosition;
          },
          onVerticalDragUpdate: (details) {
            final moveOffset = details.globalPosition;
            final diffY = moveOffset.dy - _captureOffset!.dy;

            _animationController.value =
                _animationValue + diffY / (widget.weekLineHeight * 5);
          },
          onVerticalDragEnd: (details) => _handleFinishDrag(),
          onVerticalDragCancel: _handleFinishDrag,
          child: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ValueListenableBuilder<int>(
                //   valueListenable: _monthViewCurrentPage,
                //   builder: (_, value, __) {
                //     return Header(
                //       monthDate:
                //           _monthRangeList[_monthViewCurrentPage.value].firstDay,
                //       onPressed: _handleTodayPressed,
                //       dateStyle: widget.headerStyle,
                //       todayStyle: widget.todayStyle,
                //       child: widget.showNavigationArrows
                //           ? Row(
                //               children: [
                //                 IconButton(
                //                   iconSize: 16,
                //                   padding: EdgeInsets.zero,
                //                   visualDensity: VisualDensity.compact,
                //                   icon: const Icon(Icons.arrow_back_ios),
                //                   onPressed: _handlePrevPressed,
                //                 ),
                //                 IconButton(
                //                   iconSize: 16,
                //                   padding: EdgeInsets.zero,
                //                   visualDensity: VisualDensity.compact,
                //                   icon: const Icon(Icons.arrow_forward_ios),
                //                   onPressed: _handleNextPressed,
                //                 ),
                //               ],
                //             )
                //           : null,
                //     );
                //   },
                // ),
                WeekDays(
                  style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 14,
                        color: const Color(0x42000000),
                      ) ??
                      TextStyle(
                        fontSize: 14,
                        color: const Color(0x42000000),
                      ),
                  keepLineSize: widget.keepLineSize,
                  weekNames: _weekNames != null
                      ? _weekNames!
                      : const <String>['日', '一', '二', '三', '四', '五', '六'],
                ),
                SizedBox(
                  height: 5,
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, __) {
                    return ValueListenableBuilder<int>(
                      valueListenable: _monthViewCurrentPage,
                      builder: (context, pageValue, child) {
                        // 计算当前月份实际需要的周数
                        final currentMonthView =
                            _monthRangeList[_monthViewCurrentPage.value];
                        int actualWeeksNeeded = widget.weeksInMonthViewAmount;
                        for (int weekIndex = widget.weeksInMonthViewAmount - 1;
                            weekIndex >= 0;
                            weekIndex--) {
                          final weekStart = weekIndex * 7;
                          if (weekStart + 7 <= currentMonthView.dates.length) {
                            final weekDates = currentMonthView.dates
                                .sublist(weekStart, weekStart + 7);
                            final hasCurrentMonthDate = weekDates.any((date) =>
                                date.month == currentMonthView.firstDay.month);
                            if (hasCurrentMonthDate) {
                              actualWeeksNeeded = weekIndex + 1;
                              break;
                            }
                          }
                        }

                        final height = Tween<double>(
                          begin: widget.weekLineHeight + 10, // 收起时的高度（单行高度）
                          end: widget.weekLineHeight *
                              actualWeeksNeeded, // 展开时的高度（根据实际周数）
                        ).transform(_animationController.value);

                        return SizedBox(
                          height: height,
                          child: ValueListenableBuilder<DateTime>(
                            valueListenable: _controller,
                            builder: (_, selectedDate, __) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  IgnorePointer(
                                    ignoring: _animationController.value == 0.0,
                                    child: Opacity(
                                      opacity: Tween<double>(
                                        begin: 0.0,
                                        end: 1.0,
                                      ).evaluate(_animationController),
                                      child: PageView.builder(
                                        onPageChanged: (pageIndex) {
                                          if (widget.onHorizontalDrag != null) {
                                            widget.onHorizontalDrag!(
                                              _monthRangeList[pageIndex]
                                                  .firstDay,
                                            );
                                          }
                                          _monthViewCurrentPage.value =
                                              pageIndex;
                                        },
                                        controller: _monthPageController,
                                        physics: _animationController.value ==
                                                1.0
                                            ? const SensitivePageScrollPhysics()
                                            : const NeverScrollableScrollPhysics(),
                                        itemCount: _monthRangeList.length,
                                        itemBuilder: (_, pageIndex) {
                                          return MonthView(
                                            innerDot: widget.innerDot,
                                            monthView:
                                                _monthRangeList[pageIndex],
                                            todayDate: _todayDate,
                                            selectedDate: selectedDate,
                                            weekLineHeight:
                                                widget.weekLineHeight,
                                            weeksAmount:
                                                widget.weeksInMonthViewAmount,
                                            onChanged: _handleDateChanged,
                                            events: widget.events,
                                            keepLineSize: widget.keepLineSize,
                                            textStyle: widget.calendarTextStyle,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  ValueListenableBuilder<int>(
                                    valueListenable: _monthViewCurrentPage,
                                    builder: (_, pageIndex, __) {
                                      var index = selectedDate.findWeekIndex(
                                        _monthRangeList[
                                                _monthViewCurrentPage.value]
                                            .dates,
                                      );
                                      // 如果找不到日期（index == -1），使用默认值 0（第一周）
                                      if (index < 0) {
                                        index = 0;
                                      }
                                      // 在完全收起状态下，强制居中显示（offset = 0）
                                      // 这样周视图的 PageView 中间页就会显示今天所在的周
                                      final offset = _animationController
                                                  .value ==
                                              0.0
                                          ? 0.0
                                          : index /
                                                  (widget.weeksInMonthViewAmount -
                                                      1) *
                                                  2 -
                                              1.0;
                                      return Align(
                                        alignment: Alignment(0.0, offset),
                                        child: IgnorePointer(
                                          ignoring:
                                              _animationController.value == 1.0,
                                          child: Opacity(
                                            opacity: Tween<double>(
                                              begin: 1.0,
                                              end: 0.0,
                                            ).evaluate(_animationController),
                                            child: SizedBox(
                                              height: widget.weekLineHeight,
                                              child: PageView.builder(
                                                onPageChanged: (indexPage) {
                                                  final pageIndex =
                                                      _monthRangeList
                                                          .indexWhere(
                                                    (index) =>
                                                        index.firstDay.month ==
                                                        _weekRangeList[
                                                                indexPage]
                                                            .first
                                                            .month,
                                                  );

                                                  if (widget.onHorizontalDrag !=
                                                      null) {
                                                    widget.onHorizontalDrag!(
                                                      _monthRangeList[pageIndex]
                                                          .firstDay,
                                                    );
                                                  }
                                                  _monthViewCurrentPage.value =
                                                      pageIndex;
                                                },
                                                controller: _weekPageController,
                                                itemCount:
                                                    _weekRangeList.length,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index) {
                                                  return WeekView(
                                                    innerDot: widget.innerDot,
                                                    dates:
                                                        _weekRangeList[index],
                                                    selectedDate: selectedDate,
                                                    lineHeight:
                                                        widget.weekLineHeight,
                                                    onChanged:
                                                        _handleWeekDateChanged,
                                                    events: widget.events,
                                                    keepLineSize:
                                                        widget.keepLineSize,
                                                    textStyle: widget
                                                        .calendarTextStyle,
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
                HandleBar(
                  animationController: _animationController,
                  onPressed: () async {
                    if (_animationController.value >= 0.5) {
                      // 当前是展开状态，执行收起
                      final currentMonthFirstDay =
                          _monthRangeList[_monthViewCurrentPage.value].firstDay;
                      final today = DateTime.now().toZeroTime();
                      final selectedDate = _controller.value;

                      // 判断当前显示的是否是本月
                      final isCurrentMonth =
                          currentMonthFirstDay.year == today.year &&
                              currentMonthFirstDay.month == today.month;

                      // 判断选中的日期是否在当前显示的月份
                      final isSelectedInCurrentMonth =
                          selectedDate.year == currentMonthFirstDay.year &&
                              selectedDate.month == currentMonthFirstDay.month;

                      // 决定使用哪个日期生成周视图
                      DateTime dateForWeekView;
                      if (isSelectedInCurrentMonth) {
                        // 优先：如果选中了当前月份的日期，显示选中日期所在的周
                        dateForWeekView = selectedDate;
                      } else if (isCurrentMonth) {
                        // 本月且没有选中：显示今天所在的周
                        dateForWeekView = today;
                      } else {
                        // 其他月份且没有选中该月的日期：显示该月第一周
                        dateForWeekView = currentMonthFirstDay;
                      }

                      _weekRangeList = dateForWeekView.generateWeeks(
                        widget.preloadWeekViewAmount,
                        startWeekDay: widget.startWeekDay,
                      );
                      // 跳转到周视图的中间页
                      _weekPageController!
                          .jumpToPage(widget.preloadWeekViewAmount ~/ 2);

                      await _animationController.reverse();
                      _animationValue = 0.0;
                    } else {
                      // 当前是收起状态，执行展开
                      await _animationController.forward();
                      _animationValue = 1.0;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _monthPageController!.dispose();
    _monthViewCurrentPage.dispose();

    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  void _handleWeekDateChanged(DateTime date) {
    _handleDateChanged(date);

    _monthViewCurrentPage.value = _monthRangeList
        .lastIndexWhere((monthRange) => monthRange.dates.contains(date));
  }

  void _handleDateChanged(DateTime date) {
    _controller.value = date;
  }

  void _handleFinishDrag() async {
    _captureOffset = null;

    if (_animationController.value > 0.5) {
      await _animationController.forward();
      _animationValue = 1.0;
    } else {
      await _animationController.reverse();
      _animationValue = 0.0;
    }
  }

  void _handleTodayPressed() {
    _controller.value = DateTime.now().toZeroTime();

    _monthPageController!.jumpToPage(widget.preloadMonthViewAmount ~/ 2);
    _weekPageController!.jumpToPage(widget.preloadWeekViewAmount ~/ 2);
  }

  void _handlePrevPressed() {
    final isMonthView = _animationController.value >= 0.5;

    if (isMonthView) {
      _monthPageController?.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _weekPageController?.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleNextPressed() {
    final isMonthView = _animationController.value >= 0.5;

    if (isMonthView) {
      _monthPageController!.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _weekPageController!.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
