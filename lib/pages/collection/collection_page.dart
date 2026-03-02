import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/pages/collection/collection_viewmodel.dart';
import 'package:wan_android_flutter/repository/model/my_collects_model.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/utils/theme_util.dart';

import '../../widgets/my_app_bar.dart';
import '../../pages/web/webview_page.dart';
import '../../pages/web/webview_widget.dart';

/// 我的收藏页面
///
/// 展示用户收藏的文章列表
/// 功能：
/// - 收藏列表展示：标题、作者、描述、分类、时间
/// - 下拉刷新和上拉加载更多
/// - 取消收藏：点击爱心按钮取消收藏
/// - 点击条目跳转WebView查看文章详情
class CollectionPage extends GetView<CollectionViewModel> {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Scaffold(
      backgroundColor: isDark ? Colours.dark_bg_color : Colors.grey[50],
      appBar: MyAppBar(
        centerTitle: AppStrings.getString('my_collection'),
      ),
      body: SafeArea(
        child: SmartRefresher(
          controller: controller.refreshController,
          onRefresh: () => controller.refreshOrLoad(false),
          onLoading: () => controller.refreshOrLoad(true),
          child: Obx(() {
            return ListView.separated(
              itemCount: controller.dataList.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              itemBuilder: (context, index) {
                var data = controller.dataList[index];
                return _collectionItem(
                  data,
                  isDark: context.isDark,
                  onTap: () => controller.cancelCollect(
                    index,
                    "${data.id}",
                    "${data.originId}",
                  ),
                  itemClick: () {
                    Get.to(
                      WebViewPage(
                          loadResource: data.link ?? "",
                          webViewType: WebViewType.URL,
                          title: controller.dataList[index].title),
                    );
                  },
                );
              },
            );
          }),
        ),
      ),
    );
  }

  /// 构建收藏条目
  ///
  /// [item] 收藏文章数据
  /// [onTap] 取消收藏按钮点击回调
  /// [itemClick] 条目点击回调，跳转WebView
  Widget _collectionItem(MyCollectItemModel? item, {GestureTapCallback? onTap, GestureTapCallback? itemClick, required bool isDark}) {
    return GestureDetector(
      onTap: itemClick,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colours.dark_card_bg : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${item?.title}",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 40.sp,
                  color: isDark ? Colours.dark_text : Colors.black,
                ),
              ),
              if (item?.author?.isNotEmpty ?? false) ...[
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        item?.author ?? "",
                        style: TextStyle(
                          fontSize: 32.sp,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
              ],
              if (item?.desc?.isNotEmpty ?? false)
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: isDark ? Colours.dark_item_bottom_bg : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: isDark ? Colours.dark_divider : Colors.grey[200]!, width: 1),
                  ),
                  child: Text(
                    "${item?.desc}",
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: isDark ? Colours.dark_text_gray : Colors.black54,
                      height: 1.6,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.folder_open_outlined,
                        size: 32.sp,
                        color: Colors.orangeAccent,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        "${item?.chapterName}",
                        style: TextStyle(
                          fontSize: 28.sp,
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        size: 32.sp,
                        color: isDark ? Colours.dark_text_gray : Colors.grey[500],
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "${item?.niceDate}",
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: isDark ? Colours.dark_text_gray : Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 20.w),
                      GestureDetector(
                        onTap: onTap,
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Icon(
                            Icons.favorite,
                            size: 40.sp,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
