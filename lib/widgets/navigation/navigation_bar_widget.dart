import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'navigation_bar_item.dart';

/// 底部导航栏组件
class NavigationBarWidget extends StatefulWidget {
  NavigationBarWidget({
    super.key,
    required this.tabItems,
    required this.tabLabels,
    required this.tabIcons,
    required this.tabActiveIcons,
    this.currentIndex = 0,
    this.themeData,
    this.onItemChange,
    this.bottomNavigationBarType,
    this.bottomBarIconWidth,
    this.bottomBarIconHeight,
  }) {
    if (tabItems.length != tabLabels.length &&
        tabItems.length != tabIcons.length &&
        tabItems.length != tabActiveIcons.length) {
      throw Exception("tabItems、tabLabels、tabIcons、tabActiveIcon length must same！ ");
    }
  }

  //界面集合
  final List<Widget> tabItems;

  //标题集合
  final List<String> tabLabels;

  //未选中icon
  final List<String> tabIcons;

  //选中icon
  final List<String> tabActiveIcons;

  //当前页面下标
  int currentIndex = 0;

  //底部导航栏切换事件
  final ValueChanged<int>? onItemChange;

  //页面主题
  final ThemeData? themeData;

  //底部导航栏风格
  final BottomNavigationBarType? bottomNavigationBarType;

  //底部导航栏icon宽高
  final double? bottomBarIconWidth;
  final double? bottomBarIconHeight;

  @override
  State<StatefulWidget> createState() {
    return _NavigationBarWidgetState();
  }
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //  tab 页面
      body: IndexedStack(index: widget.currentIndex, children: widget.tabItems),
      //  底部导航栏
      bottomNavigationBar: Theme(
        data: widget.themeData ??
            Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: widget.bottomNavigationBarType ?? BottomNavigationBarType.fixed,
          currentIndex: widget.currentIndex,
          items: _barItemList(),
          onTap: (index) {
            //  重复事件不处理
            if (widget.currentIndex == index) {
              return;
            }
            //  点击切换 page 事件
            widget.onItemChange?.call(index);
            widget.currentIndex = index;
            setState(() {});
          },
        ),
      ),
    );
  }

  /// 底部导航栏集合
  List<BottomNavigationBarItem> _barItemList() {
    List<BottomNavigationBarItem> items = [];

    for (var i = 0; i < widget.tabItems.length; i++) {
      var item = BottomNavigationBarItem(
        activeIcon: NavigationBarItem(
          builder: (_) => Image.asset(
            widget.tabActiveIcons[i],
            width: widget.bottomBarIconWidth ?? 28.w,
            height: widget.bottomBarIconHeight ?? 28.w,
          ),
        ),
        icon: Image.asset(
          widget.tabIcons[i],
          width: widget.bottomBarIconWidth ?? 28.w,
          height: widget.bottomBarIconHeight ?? 28.w,
        ),
        label: widget.tabLabels[i],
      );
      items.add(item);
    }
    return items;
  }
}
