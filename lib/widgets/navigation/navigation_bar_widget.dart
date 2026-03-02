import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/utils/theme_util.dart';

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
    this.bottomBarIconWidth,
    this.bottomBarIconHeight,
  }) {
    if (tabItems.length != tabLabels.length &&
        tabItems.length != tabIcons.length &&
        tabItems.length != tabActiveIcons.length) {
      throw Exception("tabItems、tabLabels、tabIcons、tabActiveIcon length must same！ ");
    }
  }

  /// 界面集合
  final List<Widget> tabItems;

  /// 标题集合
  final List<String> tabLabels;

  /// 未选中icon
  final List<String> tabIcons;

  /// 选中icon
  final List<String> tabActiveIcons;

  /// 当前页面下标
  final int currentIndex;

  /// 底部导航栏切换事件
  final ValueChanged<int>? onItemChange;

  /// 页面主题
  final ThemeData? themeData;

  /// 底部导航栏icon宽高
  final double? bottomBarIconWidth;
  final double? bottomBarIconHeight;

  @override
  State<StatefulWidget> createState() {
    return _NavigationBarWidgetState();
  }
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Scaffold(
      backgroundColor: isDark ? Colours.dark_bg_color : Colors.white,
      body: IndexedStack(index: _currentIndex, children: widget.tabItems),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 3,
        backgroundColor: isDark ? Colours.dark_card_bg : Colors.white,
        selectedItemColor: isDark ? Colors.white : Colours.app_main,
        unselectedItemColor: isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 34.sp,
        unselectedFontSize: 32.sp,
        items: _barItemList(isDark),
        onTap: (index) {
          if (_currentIndex == index) {
            return;
          }
          widget.onItemChange?.call(index);
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  /// 底部导航栏集合
  ///
  /// [isDark] 是否为深色模式
  List<BottomNavigationBarItem> _barItemList(bool isDark) {
    List<BottomNavigationBarItem> items = [];

    for (var i = 0; i < widget.tabItems.length; i++) {
      var item = BottomNavigationBarItem(
        activeIcon: NavigationBarItem(
          builder: (_) => Image.asset(
            widget.tabActiveIcons[i],
            width: widget.bottomBarIconWidth ?? 64.r,
            height: widget.bottomBarIconHeight ?? 64.r,
          ),
        ),
        icon: ColorFiltered(
          colorFilter: ColorFilter.mode(
            isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey,
            BlendMode.srcIn,
          ),
          child: Image.asset(
            widget.tabIcons[i],
            width: widget.bottomBarIconWidth ?? 60.r,
            height: widget.bottomBarIconHeight ?? 60.r,
          ),
        ),
        label: widget.tabLabels[i],
      );
      items.add(item);
    }
    return items;
  }
}
