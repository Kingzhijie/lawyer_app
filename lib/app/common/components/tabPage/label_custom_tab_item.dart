import 'package:flutter/material.dart';
import '../../../utils/event_until.dart';
import '../../../utils/object_utils.dart';
import 'label_tab_bar.dart';
import 'custom_systom_tab_bar.dart' as CustomTab;

class LabelCustomTabItem extends StatefulWidget {
  final List<LabelTopBarModel>? tabModelArr; //tab对象数组
  final List<String>? titles;
  final Color? indicatorColor; //指示器颜色
  final Color labelColor; //选中label颜色
  final Color unselectedLabelColor; //未选中label颜色
  final double indicatorWeight; // 指示器 高度 默认2
  final Decoration? indicator; //指示器样式
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool isScrollable; //标签是否可左右滚动
  final EdgeInsets? padding; //内边距
  final EdgeInsetsGeometry? labelPadding; //tab文字间距, null, 默认间距
  final TabController? tabController;
  final String? reloadBadgesKey;

  const LabelCustomTabItem(
      {super.key,
      this.tabModelArr,
      this.titles,
      this.indicatorColor,
      required this.labelColor,
      required this.unselectedLabelColor,
      required this.indicatorWeight,
      this.indicator,
      this.labelStyle,
      this.unselectedLabelStyle,
      required this.isScrollable,
      this.padding,
      this.labelPadding,
      this.reloadBadgesKey,
      this.tabController});

  @override
  State<LabelCustomTabItem> createState() => _LabelCustomTabItemState();
}

class _LabelCustomTabItemState extends State<LabelCustomTabItem> {
  late final _badgesCountListener = EventListener<List<int?>>((data) {
    _badgesCount = data;
    if (mounted) {
      setState(() {});
    }
  });
  List<int?>? _badgesCount;

  @override
  void initState() {
    super.initState();
    if (widget.reloadBadgesKey != null) {
      widget.reloadBadgesKey!.on<List<int?>>(_badgesCountListener);
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.reloadBadgesKey != null) {
      widget.reloadBadgesKey!.off(_badgesCountListener);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTab.TabBar(
      padding: widget.padding,
      isScrollable: widget.isScrollable,
      controller: widget.tabController,
      indicatorColor: widget.indicatorColor,
      indicatorWeight: widget.indicatorWeight,
      labelPadding: widget.labelPadding,
      labelColor: widget.labelColor,
      unselectedLabelColor: widget.unselectedLabelColor,
      labelStyle: widget.labelStyle,
      indicatorSize: TabBarIndicatorSize.label,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      indicator: widget.indicator,
      splashFactory: NoSplash.splashFactory, // 去掉波纹效果
      overlayColor: WidgetStateProperty.all(Colors.transparent), // 去掉点击高亮
      tabs: _setTabs(),
    );
  }

  List<Widget> _setTabs() {
    List<Widget> tabs = [];
    if (!ObjectUtils.isEmpty(widget.tabModelArr)) {
      for (int i = 0; i < widget.tabModelArr!.length; i++) {
        LabelTopBarModel item = widget.tabModelArr![i];
        tabs.add(Tab(
          text: item.title,
        ));
      }
    } else if (!ObjectUtils.isEmpty(widget.titles)) {
      for (var e in widget.titles!) {
        tabs.add(Tab(
          text: e,
        ));
      }
    }
    return tabs;
  }
}
