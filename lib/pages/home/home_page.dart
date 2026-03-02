import 'dart:developer';
import 'dart:math' hide log;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/pages/home/home_viewmodel.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
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
          header: ClassicHeader(
            height: 60.h,
            idleText: AppStrings.getString('pull_down_refresh'),
            releaseText: AppStrings.getString('release_refresh'),
            refreshingText: AppStrings.getString('refreshing'),
            completeText: AppStrings.getString('refresh_complete'),
            failedText: AppStrings.getString('refresh_failed'),
            completeDuration: Duration(milliseconds: 100),
            textStyle: TextStyle(color: Colours.app_main, fontSize: 28.sp),
            idleIcon: Icon(Icons.arrow_downward, color: Colours.app_main, size: 40.r),
            refreshingIcon: SizedBox(
              width: 40.r,
              height: 40.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main),
              ),
            ),
          ),
          physics: const ClampingScrollPhysics(),
          footer: ClassicFooter(
            height: 60.h,
            loadingText: AppStrings.getString('loading'),
            canLoadingText: AppStrings.getString('release_load'),
            idleText: AppStrings.getString('pull_up_load_more'),
            noDataText: AppStrings.getString('no_more_data'),
            failedText: AppStrings.getString('load_failed'),
            textStyle: TextStyle(color: Colours.app_main, fontSize: 28.sp),
            loadingIcon: SizedBox(
              width: 40.r,
              height: 40.r,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main),
              ),
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
                      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Stack(
        children: [
          Obx(() {
            return SizedBox(
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: controller.currentUrl.value,
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colours.app_main.withValues(alpha: 0.3),
                            Colours.app_main.withValues(alpha: 0.6)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Icon(Icons.image,
                          size: 80.r, color: Colors.grey[400]),
                    ),
                  ),
                ),
              ),
            );
          }),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.1),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
            ),
          ),
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
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 24.w),
          Expanded(
            child: GestureDetector(
              onTap: () => Get.toNamed(RoutePath.search),
              child: Container(
                height: 80.h,
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[100]!, Colors.grey[50]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(40.r),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.grey[400],
                      size: 48.r,
                    ),
                    SizedBox(width: 24.w),
                    Text(
                      AppStrings.getString('search_hint'),
                      style: TextStyle(
                        fontSize: 41.sp,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 20.w),
          InkWell(
            onTap: () => {Get.toNamed(RoutePath.scan)},
            borderRadius: BorderRadius.circular(24.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Image.asset(
                "assets/images/icon_scan.png",
                width: 80.r,
                height: 80.r,
              ),
            ),
          ),
          SizedBox(width: 24.w),
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
    int randomNumber =
        item?.id?.hashCode ?? DateTime.now().millisecondsSinceEpoch;
    String imageUrl = 'https://picsum.photos/300/400?random=$randomNumber';
    String? name =
        TextUtil.isEmpty(item?.author) ? item?.shareUser : item?.author;
    return GestureDetector(
      onTap: onItemClick,
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(32.w, 32.w, 32.w, 0),
              child: Row(
                children: [
                  Container(
                    width: 80.r,
                    height: 80.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colours.app_main.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: imageUrl,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.person,
                              color: Colors.grey[400], size: 40.r),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: Icon(Icons.person,
                              color: Colors.grey[400], size: 40.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 24.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name ?? "",
                          style: TextStyle(
                            fontSize: 37.sp,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          item?.niceShareDate ?? "",
                          style: TextStyle(
                            fontSize: 31.sp,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (item?.type == 1)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colours.app_main,
                            Colours.app_main.withValues(alpha: 0.8)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        AppStrings.getString('pinned'),
                        style: TextStyle(
                          fontSize: 29.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    )
                ],
              ),
            ),
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                item?.title ?? "",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 41.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
            SizedBox(height: 28.h),
            Container(
              padding: EdgeInsets.fromLTRB(32.w, 24.w, 32.w, 32.w),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
                ),
              ),
              child: Row(children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colours.app_main.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    "${item?.superChapterName ?? ""} • ${item?.chapterName ?? ""}",
                    style: TextStyle(
                        fontSize: 31.sp,
                        color: Colours.app_main,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const Expanded(child: SizedBox()),
                GetBuilder<HomeViewModel>(
                    id: item?.id.toString() ?? "",
                    builder: (controller) {
                      log("GetBuilder collectImage");
                      return collectImage(item?.collect, onTap: imageClick);
                    })
              ]),
            )
          ],
        ),
      ),
    );
  }
}
