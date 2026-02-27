import 'dart:developer';
import 'dart:math' hide log;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/pages/home/home_viewmodel.dart';
import 'package:wan_android_flutter/res/colors.dart';

import '../../repository/model/home_list_model.dart';
import '../../route/route_path_constant.dart';
import '../../widgets/banner/home_banner_widget.dart';
import '../../widgets/common_styles.dart';
import '../../widgets/web/webview_page.dart';
import '../../widgets/web/webview_widget.dart';

/// 首页文章列表页面
class HomePage extends GetView<HomeViewModel> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.bg_color,
      body: SafeArea(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          controller: controller.refreshController,
          // 自定义 Header
          header: const ClassicHeader(
            idleText: '下拉刷新',
            releaseText: '释放刷新',
            refreshingText: '刷新中...',
            completeText: '刷新完成',
            failedText: '刷新失败',
            // 缩短完成动画时长
            completeDuration: Duration(milliseconds: 100),
            // 设置刷新过程中的颜色
            textStyle: TextStyle(color: Colours.app_main),
            idleIcon: Icon(Icons.arrow_downward, color: Colours.app_main),
            refreshingIcon: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main),
            ),
          ),
          // 使用固定滚动物理，彻底关闭回弹效果
          physics: const ClampingScrollPhysics(),
          // 自定义 Footer
          footer: const ClassicFooter(
            loadingText: '加载中...',
            canLoadingText: '释放加载',
            idleText: '上拉加载更多',
            noDataText: '没有更多数据',
            failedText: '加载失败',
            // 设置加载过程中的颜色
            textStyle: TextStyle(color: Colours.app_main),
            loadingIcon: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main),
            ),
          ),
          onLoading: () {
            controller.refreshOrLoad(true);
          },
          onRefresh: () {
            controller.refreshOrLoad(false);
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                _topSearchBar(),
                SizedBox(height: 8.h),
                _banner(),
                Obx(() {
                  return ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.listData.length,
                      itemBuilder: (BuildContext context, int index) {
                        HomeListItemData? item = controller.listData[index];
                        return _listItem(
                          item: item,
                          onItemClick: () {
                            Get.to(
                              WebViewPage(
                                  loadResource: item.link ?? "", webViewType: WebViewType.URL, title: item.title),
                            );
                          },
                          imageClick: () {
                            if (item.collect == true) {
                              //  取消收藏
                              controller.cancelCollect(index, "${item.id}");
                            } else {
                              //  收藏
                              controller.collect(index, "${item.id}");
                            }
                          },
                        );
                      });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _banner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Stack(
        children: [
          Obx(() {
            return SizedBox(
              width: double.infinity, // 宽度占满父容器（通常是屏幕）
              child: AspectRatio(
                aspectRatio: 9 / 4, // 减小banner高度，从9/5调整为9/4
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: controller.currentUrl.value,
                  ),
                ),
              ),
            );
          }),
          BannerWidget(
            controller: controller.bannerController,
            itemClick: (title, url) {
              Get.to(
                WebViewPage(
                  loadResource: url,
                  webViewType: WebViewType.URL,
                  title: title,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _topSearchBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        children: [
          SizedBox(width: 12.w),
          Expanded(
            child: GestureDetector(
              onTap: () => Get.toNamed(RoutePath.search),
              child: Container(
                height: 100.h,
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey[100]!,
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey,
                      size: 88.r,
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      "搜索玩安卓",
                      style: TextStyle(
                        fontSize: 60.sp,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          InkWell(
            onTap: () => {Get.toNamed(RoutePath.scan)},
            child: Image.asset(
              "assets/images/icon_scan.png",
              width: 128.w,
              height: 128.h,
            ),
          ),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }

  /// 列表 item
  Widget _listItem({
    HomeListItemData? item,
    GestureTapCallback? onItemClick,
    GestureTapCallback? imageClick,
  }) {
    int randomNumber = Random().nextInt(10000);
    String imageUrl = 'https://picsum.photos/300/400?random=$randomNumber';
    String? name = TextUtil.isEmpty(item?.author) ? item?.shareUser : item?.author;
    return GestureDetector(
      onTap: onItemClick,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Container(
          padding: EdgeInsets.all(42.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      width: 72.r,
                      height: 72.r,
                      fit: BoxFit.cover,
                      imageUrl: imageUrl,
                    ),
                  ),
                  SizedBox(width: 30.w),
                  Expanded(
                    child: Text(
                      name ?? "",
                      style: TextStyle(
                        fontSize: 30.sp,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 30.w),
                  Text(
                    item?.niceShareDate ?? "",
                    style: TextStyle(
                      fontSize: 27.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(width: 30.w),
                  if (item?.type == 1)
                    Text(
                      "置顶",
                      style: TextStyle(
                        fontSize: 27.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueAccent,
                      ),
                    )
                ],
              ),
              SizedBox(height: 30.h),
              Text(
                item?.title ?? "",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 33.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              SizedBox(height: 30.h),
              Row(children: [
                Text(
                  "${item?.superChapterName ?? ""} • ${item?.chapterName ?? ""}",
                  style: TextStyle(fontSize: 27.sp, color: Colours.app_main, fontWeight: FontWeight.w500),
                ),
                const Expanded(child: SizedBox()),
                GetBuilder<HomeViewModel>(
                    id: item?.id.toString() ?? "",
                    builder: (controller) {
                      log("GetBuilder collectImage");
                      return collectImage(item?.collect, onTap: imageClick);
                    })
              ])
            ],
          ),
        ),
      ),
    );
  }
}