import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/utils/theme_util.dart';

import 'navigation_bar_item.dart';

/// 底部导航栏组件
class NavigationBarWidget extends StatefulWidget {
  /// 创建底部导航栏组件
  ///
  /// [currentIndex] 当前选中的页面索引
  /// [tabLabels] 导航栏项标题列表
  /// [tabIcons] 未选中状态的图标路径列表
  /// [tabActiveIcons] 选中状态的图标路径列表
  /// [onItemChange] 导航栏项切换回调
  /// [bottomBarIconWidth] 图标宽度
  /// [bottomBarIconHeight] 图标高度
  const NavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.tabLabels,
    required this.tabIcons,
    required this.tabActiveIcons,
    this.onItemChange,
    this.bottomBarIconWidth,
    this.bottomBarIconHeight,
  }) : assert(tabLabels.length == tabIcons.length && tabLabels.length == tabActiveIcons.length,
            'tabLabels、tabIcons、tabActiveIcons 长度必须相同！');

  /// 当前页面下标
  final int currentIndex;

  /// 标题集合
  final List<String> tabLabels;

  /// 未选中icon路径集合
  final List<String> tabIcons;

  /// 选中icon路径集合
  final List<String> tabActiveIcons;

  /// 底部导航栏切换事件回调
  final ValueChanged<int>? onItemChange;

  /// 底部导航栏icon宽度
  final double? bottomBarIconWidth;

  /// 底部导航栏icon高度
  final double? bottomBarIconHeight;

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final themeData = Theme.of(context);

    return BottomNavigationBar(
      elevation: 3,
      backgroundColor: _getBackgroundColor(isDark),
      selectedItemColor: _getSelectedItemColor(isDark, themeData),
      unselectedItemColor: _getUnselectedItemColor(isDark),
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.currentIndex,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedFontSize: 34.sp,
      unselectedFontSize: 32.sp,
      items: _buildNavigationItems(isDark),
      onTap: _handleItemTap,
    );
  }

  /// 获取导航栏背景颜色
  Color _getBackgroundColor(bool isDark) =>
      isDark ? Colours.dark_card_bg : Colors.white;

  /// 获取选中项颜色
  Color _getSelectedItemColor(bool isDark, ThemeData themeData) =>
      isDark ? Colors.white : themeData.primaryColor;

  /// 获取未选中项颜色
  Color _getUnselectedItemColor(bool isDark) =>
      isDark ? Colors.white.withValues(alpha: 0.6) : Colors.grey;

  /// 处理导航栏项点击事件
  void _handleItemTap(int index) {
    if (widget.currentIndex == index) return;
    widget.onItemChange?.call(index);
  }

  /// 构建导航栏项列表
  List<BottomNavigationBarItem> _buildNavigationItems(bool isDark) {
    return List.generate(widget.tabLabels.length, (index) {
      return BottomNavigationBarItem(
        activeIcon: _buildActiveIcon(index),
        icon: _buildInactiveIcon(index, isDark),
        label: widget.tabLabels[index],
      );
    });
  }

  /// 构建选中状态的图标
  Widget _buildActiveIcon(int index) {
    return NavigationBarItem(
      builder: (_) => Image.asset(
        widget.tabActiveIcons[index],
        width: widget.bottomBarIconWidth ?? 64.r,
        height: widget.bottomBarIconHeight ?? 64.r,
      ),
    );
  }

  /// 构建未选中状态的图标
  Widget _buildInactiveIcon(int index, bool isDark) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        isDark ? Colors.black.withValues(alpha: 0.5) : Colors.grey,
        BlendMode.srcIn,
      ),
      child: Image.asset(
        widget.tabIcons[index],
        width: widget.bottomBarIconWidth ?? 60.r,
        height: widget.bottomBarIconHeight ?? 60.r,
      ),
    );
  }
}
