import 'package:flutter/material.dart';
import '../../../utils/event_until.dart';
import 'custom_systom_tab_bar.dart' as CustomTab;
import 'label_custom_tab_item.dart';
import 'refreshNotification/push_to_refresh_header.dart';
import 'refreshNotification/src/pull_to_refresh_notification.dart';
import 'sliver_app_bar_delegate.dart';

class LabelTopBarModel {
  final String title;
  final Widget widget; //对应的widget
  int? id;
  int? count; //数量

  LabelTopBarModel(
    this.title,
    this.widget, {
    this.id,
    this.count,
  }); //标题
}

enum ListenerLabelTabBarType { home, other }

// ignore: must_be_immutable
class LabelTabBar extends StatefulWidget {
  List<LabelTopBarModel> tabModelArr; //tab对象数组
  final Color bgColor; //TabBar背景颜色，
  final BorderRadius? radius; //圆角
  final Color? indicatorColor; //指示器颜色
  final Color labelColor; //选中label颜色
  final Color unselectedLabelColor; //未选中label颜色
  final double indicatorWeight; // 指示器 高度 默认2
  final Decoration? indicator; //指示器样式
  final double height; //tab高度 默认35
  final double width; //tab宽度, 默认屏幕宽度
  final double? rightSpace; //右边缩进
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final Function(int index)? switchPageCallBack; //页面切换的回调，返回index
  final bool isScrollable; //标签是否可左右滚动
  final EdgeInsets? padding; //内边距
  final ListenerLabelTabBarType addListenerType; //是否添加头部监听
  final bool isShowBottomLine; //是否显示底部分分割线
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? labelPadding; //tab文字间距, null, 默认间距
  final String?
      reloadBadgesKey; //刷新, tab数量角标 (注, 通知参数-list数量必须和tabModelArr保持一致, 切对应)

  /*头部有高度,  悬停tab需要穿参数*/
  final Widget? topWidget; // 头部内容
  final ScrollController? scrollController;
  final int defaultSelectIndex; //默认选中
  final Future<bool> Function()? onRefresh; //是否包含下拉刷新 <当topWidget null时, 此属性无效>

  LabelTabBar(this.tabModelArr,
      {Key? key,
      this.bgColor = Colors.white,
      this.indicatorColor,
      this.labelColor = Colors.black,
      this.unselectedLabelColor = Colors.black45,
      this.indicatorWeight = 2,
      this.height = 35,
      this.labelStyle,
      this.unselectedLabelStyle,
      this.switchPageCallBack,
      this.width = double.infinity,
      this.indicator,
        this.rightSpace,
      this.isScrollable = false,
      this.padding,
      this.physics,
      this.labelPadding,
      this.reloadBadgesKey,
      this.isShowBottomLine = true,
      this.topWidget,
      this.scrollController,
      this.defaultSelectIndex = 0,
      this.addListenerType = ListenerLabelTabBarType.other,
      this.radius,
      this.onRefresh})
      : super(key: key);

  @override
  _LabelTabBarState createState() => _LabelTabBarState();
}

class _LabelTabBarState extends State<LabelTabBar>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _setInitTabController();
  }

  /// tab初始化
  _setInitTabController() {
    if (!mounted) {
      return;
    }
    _tabController?.removeListener(() {});
    _tabController = TabController(
        length: widget.tabModelArr.length,
        initialIndex:
            widget.defaultSelectIndex > (widget.tabModelArr.length - 1)
                ? (widget.tabModelArr.length - 1)
                : widget.defaultSelectIndex,
        vsync: this);
    if (_tabController != null) {
      _tabController!.addListener(() {
        if (widget.switchPageCallBack != null) {
          if (_tabController!.index.toDouble() ==
              _tabController!.animation?.value) {
            widget.switchPageCallBack!(_tabController!.index);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(() {});
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.topWidget == null
        ? _setTabBarContainer()
        : widget.onRefresh != null
            ? PullToRefreshNotification(
                maxDragOffset: maxDragOffset,
                onRefresh: widget.onRefresh!,
                child: _setNestedScrollView())
            : _setNestedScrollView();
  }

  // 滚动范围
  Widget _setNestedScrollView() {
    return NestedScrollView(
        controller: widget.scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            if (widget.onRefresh != null)
              PullToRefreshContainer(
                (PullToRefreshScrollNotificationInfo? info) {
                  return SliverToBoxAdapter(
                    child: PullToRefreshHeader(info),
                  );
                },
              ),

            SliverToBoxAdapter(
              child: widget.topWidget!,
            ),

            /// TabBar部分
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverPersistentHeader(
                delegate: SliverAppBarDelegate(_setTabBar()),
                pinned: true, //头部悬停
              ),
            ),
          ];
        },
        body: _setContentItem());
  }

  //自定义tabBar容器
  Widget _setTabBarContainer() {
    return Column(
      children: [
        SizedBox(
            height: widget.height, width: widget.width, child: _setTabBar()),
        Expanded(
          child: _setContentItem(),
        )
      ],
    );
  }


  //自定义tabBar
  PreferredSize _setTabBar() {
    return PreferredSize(
        preferredSize: Size(widget.width, widget.height),
        child: Container(
          decoration: BoxDecoration(
              color: widget.bgColor,
              borderRadius: widget.radius,
              border: widget.isShowBottomLine
                  ? const Border(bottom: BorderSide(color: Color(0xFFF6F6F6)))
                  : null),
          padding: EdgeInsets.only(right: widget.rightSpace ?? 0),
          child: _tabController?.length != widget.tabModelArr.length
              ? Container()
              : LabelCustomTabItem(
              padding: widget.padding,
              isScrollable: widget.isScrollable,
              tabController: _tabController,
              indicatorColor: widget.indicatorColor,
              indicatorWeight: widget.indicatorWeight,
              labelPadding: widget.labelPadding,
              labelColor: widget.labelColor,
              unselectedLabelColor: widget.unselectedLabelColor,
              labelStyle: widget.labelStyle,
              unselectedLabelStyle: widget.unselectedLabelStyle,
              indicator: widget.indicator,
              reloadBadgesKey: widget.reloadBadgesKey,
              tabModelArr: widget.tabModelArr),
        ));
  }

  //设置内容
  Widget _setContentItem() {
    if (_tabController?.length != widget.tabModelArr.length) {
      return Container();
    }
    return Container(
      margin: widget.topWidget == null
          ? EdgeInsets.zero
          : EdgeInsets.only(top: widget.height),
      child: TabBarView(
        physics: widget.physics,
        controller: _tabController,
        children: widget.tabModelArr.map((item) => item.widget).toList(),
      ),
    );
  }

}

// 自定义, label标签 Indicator
class MyUnderlineTabIndicator extends Decoration {
  /// Create an underline style selected tab indicator.
  ///
  /// The [borderSide] and [insets] arguments mull.
  const MyUnderlineTabIndicator({
    this.width,
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
  });

  /// The color and weight of the horizontal line drawn below the selected tab.
  final BorderSide borderSide;
  final double? width;

  /// Locates the selected tab's underline relative to the tab's boundary.
  ///
  /// The [TabBar.indicatorSize] property can be used to define the tab
  /// indicator's bounds in terms of its (centered) tab widget with
  /// [TabBarIndicatorSize.label], or the entire tab with
  /// [TabBarIndicatorSize.tab].
  final EdgeInsetsGeometry insets;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _MyUnderlineTabIndicator(this, onChanged);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    double targetWidth = width ?? indicator.width;
    double cw = (indicator.left + indicator.right) / 2;
    return Rect.fromLTWH(
      cw - targetWidth / 2,
      indicator.bottom - borderSide.width,
      targetWidth,
      borderSide.width,
    );
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _MyUnderlineTabIndicator extends BoxPainter {
  _MyUnderlineTabIndicator(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  final MyUnderlineTabIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Rect indicator = decoration
        ._indicatorRectFor(rect, textDirection)
        .deflate(decoration.borderSide.width / 2.0);
    final Paint paint = decoration.borderSide.toPaint()
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
  }
}
