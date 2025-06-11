import 'dart:developer';
import 'dart:math' hide log;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/pages/home/home_view_model.dart';

import '../../repository/model/home_list_model.dart';
import '../../widgets/banner/home_banner_widget.dart';
import '../../widgets/common_styles.dart';
import '../../widgets/web/webview_page.dart';
import '../../widgets/web/webview_widget.dart';

/// 首页文章列表页面
class HomeListPage extends GetView<HomeViewModel> {
  const HomeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                Stack(
                  children: [
                    Obx(() {
                      return CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: controller.currentUrl.value,
                      );
                    }),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: const SizedBox(
                        width: double.infinity,
                        height: 200.0,
                      ),
                    ),
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
                ),
                GetBuilder<HomeViewModel>(
                  builder: (controller) {
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
                  },
                ),
              ],
            ),
          ),
        ),
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
                    child: Image.network(
                      imageUrl,
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
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
                style: titleTextStyle15,
              ),
              SizedBox(height: 5.h),
              Row(children: [
                Text(
                  "${item?.superChapterName ?? ""} . ${item?.chapterName ?? ""}",
                  style: TextStyle(fontSize: 13.sp, color: Colors.green),
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
