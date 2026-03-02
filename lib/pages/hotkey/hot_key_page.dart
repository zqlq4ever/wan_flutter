import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/pages/hotkey/hot_key_viewmodel.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/route/route_path_constant.dart';
import 'package:wan_android_flutter/utils/theme_util.dart';

import '../../pages/web/webview_page.dart';
import '../../pages/web/webview_widget.dart';

/// 热搜页面
///
/// 展示搜索热词和常用网站
/// 功能：
/// - 搜索热词：展示热门搜索关键词，点击跳转搜索页
/// - 常用网站：展示常用网站链接，点击跳转WebView
class HotKeyPage extends StatefulWidget {
  const HotKeyPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HotKeyPageState();
  }
}

class _HotKeyPageState extends State<HotKeyPage> {
  /// 视图模型，管理热搜数据
  var vm = HotKeyViewModel();
  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    vm.getData();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() {
    vm.getData();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return ChangeNotifierProvider(
      create: (context) => vm,
      child: Scaffold(
        backgroundColor: isDark ? Colours.dark_bg_color : Colors.grey[50],
        body: SafeArea(
          child: RefreshConfiguration(
            headerBuilder: () => ClassicHeader(
              idleText: AppStrings.getString('pull_down_refresh'),
              releaseText: AppStrings.getString('release_refresh'),
              refreshingText: AppStrings.getString('refreshing'),
              completeText: AppStrings.getString('refresh_complete'),
              failedText: AppStrings.getString('refresh_failed'),
              refreshingIcon: SizedBox(
                width: 20.w,
                height: 20.h,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            child: SmartRefresher(
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.w),
                      padding: EdgeInsets.all(30.w),
                      decoration: BoxDecoration(
                        color: isDark ? Colours.dark_card_bg : Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _titleWidget(AppStrings.getString('search_hot_key'), isDark),
                          SizedBox(height: 24.h),
                          _searchHotKeyListView(isDark),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.w),
                      padding: EdgeInsets.all(30.w),
                      decoration: BoxDecoration(
                        color: isDark ? Colours.dark_card_bg : Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _titleWidget(AppStrings.getString('common_website'), isDark),
                          SizedBox(height: 24.h),
                          _commonWebsiteListView(isDark),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleWidget(
    String title,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: Colours.app_main,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(width: 16.w),
          _titleText(title, isDark),
        ],
      ),
    );
  }

  Text _titleText(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        color: isDark ? Colours.dark_text : Colors.black87,
        fontSize: 44.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _searchHotKeyListView(bool isDark) {
    return Consumer<HotKeyViewModel>(builder: (context, value, child) {
      return _gridview(
          itemBuilder: (context, index) {
            var keyword = value.hotKeyList[index].name;
            return _item(
              keyword,
              isDark: isDark,
              isHot: index < 3,
              onTap: () {
                Get.toNamed(RoutePath.search, arguments: {"keyword": keyword});
              },
            );
          },
          itemCount: value.hotKeyList.length);
    });
  }

  Widget _commonWebsiteListView(bool isDark) {
    return Consumer<HotKeyViewModel>(builder: (context, value, child) {
      return _gridview(
          itemBuilder: (context, index) {
            return _item(value.websiteList[index].name, isDark: isDark, onTap: () {
              Get.to(
                WebViewPage(
                    loadResource: value.websiteList[index].link ?? "",
                    webViewType: WebViewType.URL,
                    title: value.websiteList[index].name),
              );
            });
          },
          itemCount: value.websiteList.length);
    });
  }

  /// 通用网格布局
  ///
  /// [itemBuilder] 条目构建器
  /// [itemCount] 条目数量
  /// 返回禁止滑动的GridView
  Widget _gridview<T>({required NullableIndexedWidgetBuilder itemBuilder, int? itemCount}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.w),
      child: GridView.builder(
        //  禁止滑动
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 20.w,
          crossAxisSpacing: 20.w,
          childAspectRatio: 2.8,
        ),
        itemBuilder: itemBuilder,
        itemCount: itemCount,
      ),
    );
  }

  Widget _item(
    String? title, {
    GestureTapCallback? onTap,
    bool isHot = false,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            color: isHot ? Colours.app_main.withValues(alpha: 0.1) : (isDark ? Colours.dark_bg_gray : Colors.grey[100]),
            borderRadius: BorderRadius.circular(16.r),
            border: isHot
                ? Border.all(color: Colours.app_main.withValues(alpha: 0.3), width: 1)
                : null,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            title ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 33.sp,
              color: isHot ? Colours.app_main : (isDark ? Colours.dark_text : Colors.black87),
              fontWeight: isHot ? FontWeight.w600 : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
