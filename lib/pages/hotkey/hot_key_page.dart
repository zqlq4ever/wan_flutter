import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/pages/hotkey/hot_key_viewmodel.dart';
import 'package:wan_android_flutter/pages/search/search_page.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/route/route_path_constant.dart';

import '../../widgets/common_styles.dart';
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              _titleWidget("搜索热词"),
              SizedBox(height: 10.h),

              //  搜索热词列表
              _searchHotKeyListView(),
              SizedBox(height: 10.h),

              _titleWidget("常用网站"),
              SizedBox(height: 10.h),

              //  常用网站列表
              _commonWebsiteListView(),
              SizedBox(height: 10.h),
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
      height: 50.h,
      padding: EdgeInsets.only(left: 15.w, right: 15.w),
      alignment: Alignment.centerLeft,
      child: _titleText(title),
    );
  }

  Text _titleText(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colours.app_main,
        fontSize: 16.sp,
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
              onTap: () {
                Get.toNamed(RoutePath.search, arguments: {"keyword": keyword});
              },
            );
          },
          itemCount: value.hotKeyList.length);
    });
  }

  /// 常用网站列表
  Widget _commonWebsiteListView({GestureTapCallback? itemClick}) {
    return Consumer<HotKeyViewModel>(builder: (context, value, child) {
      return _gridview(
          itemBuilder: (context, index) {
            return _item(value.websiteList[index].name, onTap: () {
              Get.to(
                WebViewPage(
                    loadResource: value.websiteList[index].link ?? "",
                    webViewType: WebViewType.URL,
                    showTitle: true,
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
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      child: GridView.builder(
        //  禁止滑动
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisSpacing: 10.r, //主轴间隔
          crossAxisSpacing: 10.r, //横轴间隔
          maxCrossAxisExtent: 120.0, //最大横轴范围
          childAspectRatio: 2.0, //宽高比为2
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
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.all(
            Radius.circular(10.r),
          ),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(5.0),
        child: Text(
          title ?? "",
          textAlign: TextAlign.center,
          style: blackTextStyle13,
        ),
      ),
    );
  }
}
