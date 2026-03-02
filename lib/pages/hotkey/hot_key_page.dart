import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/pages/hotkey/hot_key_viewmodel.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/route/route_path_constant.dart';

import '../../widgets/web/webview_page.dart';
import '../../widgets/web/webview_widget.dart';

/// 热索页面
class HotKeyPage extends StatefulWidget {
  const HotKeyPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HotKeyPageState();
  }
}

class _HotKeyPageState extends State<HotKeyPage> {
  var vm = HotKeyViewModel();

  @override
  void initState() {
    super.initState();
    vm.getData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => vm,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 40.h),

              // 搜索热词区域
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                padding: EdgeInsets.all(30.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(children: [
                  _titleWidget(AppStrings.getString('search_hot_key')),
                  SizedBox(height: 24.h),
                  _searchHotKeyListView(),
                ]),
              ),

              SizedBox(height: 32.h),

              // 常用网站区域
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                padding: EdgeInsets.all(30.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(children: [
                  _titleWidget(AppStrings.getString('common_website')),
                  SizedBox(height: 24.h),
                  _commonWebsiteListView(),
                ]),
              ),

              SizedBox(height: 40.h),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _titleWidget(
    String title,
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
          _titleText(title),
        ],
      ),
    );
  }

  Text _titleText(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black87,
        fontSize: 44.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// 搜索热词列表
  Widget _searchHotKeyListView() {
    return Consumer<HotKeyViewModel>(builder: (context, value, child) {
      return _gridview(
          itemBuilder: (context, index) {
            var keyword = value.hotKeyList[index].name;
            return _item(
              keyword,
              isHot: index < 3,
              onTap: () {
                Get.toNamed(RoutePath.search, arguments: {"keyword": keyword});
              },
            );
          },
          itemCount: value.hotKeyList.length);
    });
  }

  /// 常用网站列表
  Widget _commonWebsiteListView() {
    return Consumer<HotKeyViewModel>(builder: (context, value, child) {
      return _gridview(
          itemBuilder: (context, index) {
            return _item(value.websiteList[index].name, onTap: () {
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

  /// 通用网格 item
  Widget _item(
    String? title, {
    GestureTapCallback? onTap,
    bool isHot = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            color: isHot ? Colours.app_main.withValues(alpha: 0.1) : Colors.grey[100],
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
              color: isHot ? Colours.app_main : Colors.black87,
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
