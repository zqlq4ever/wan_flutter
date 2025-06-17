import 'dart:developer';
import 'dart:math' hide log;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/pages/home/home_viewmodel.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/res/styles.dart';
import 'package:wan_android_flutter/utils/image_util.dart';

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
                SizedBox(height: 16.h),
                _banner(),
                Obx(() {
                  return ListView.builder(
                      padding: const EdgeInsets.all(16),
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
                                  loadResource: item.link ?? "",
                                  webViewType: WebViewType.URL,
                                  showTitle: true,
                                  title: item.title),
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
    return Stack(
      children: [
        Obx(() {
          return CachedNetworkImage(
            height: 200.h,
            fit: BoxFit.cover,
            imageUrl: controller.currentUrl.value,
          );
        }),
        BannerWidget(
          controller: controller.bannerController,
          itemClick: (title, url) {
            Get.to(
              WebViewPage(
                loadResource: url,
                webViewType: WebViewType.URL,
                showTitle: true,
                title: title,
              ),
            );
          },
        )
      ],
    );
  }

  Widget _topSearchBar() {
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => Get.toNamed(RoutePath.search),
            child: Container(
              height: 36.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.grey, // 图标颜色
                    size: 24.0, // 图标大小
                  ),
                  SizedBox(width: 10),
                  Text(
                    "搜索玩安卓",
                    style: TextStyles.textGray12,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: ()=>{
            Get.toNamed(RoutePath.scan)
          },
          child: Image.asset(
            "assets/images/icon_scan.png",
            width: 28.w,
            height: 28.h,
          ),
        ),
        const SizedBox(width: 16),
      ],
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
        margin: EdgeInsets.only(bottom: 16.h),
        color: Colors.white,
        elevation: 1,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(15.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      width: 20,
                      height: 20,
                      fit: BoxFit.cover,
                      imageUrl: imageUrl,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  normalText(name ?? ""),
                  const Expanded(child: SizedBox()),
                  normalText(item?.niceShareDate),
                  SizedBox(width: 10.w),
                  Text(
                    item?.type == 1 ? "置顶" : "",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent,
                    ),
                  )
                ],
              ),
              SizedBox(height: 5.h),
              Text(
                item?.title ?? "",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 5.h),
              Row(children: [
                Text(
                  "${item?.superChapterName ?? ""} • ${item?.chapterName ?? ""}",
                  style: TextStyle(fontSize: 13.sp, color: Colours.app_main),
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
