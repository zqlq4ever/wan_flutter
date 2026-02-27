import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/pages/collection/collection_viewmodel.dart';
import 'package:wan_android_flutter/repository/model/my_collects_model.dart';

import '../../widgets/common_styles.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/web/webview_page.dart';
import '../../widgets/web/webview_widget.dart';

/// 我的收藏页面
class CollectionPage extends GetView<CollectionViewModel> {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(
        centerTitle: "我的收藏",
      ),
      body: SafeArea(
        child: SmartRefresher(
          controller: controller.refreshController,
          onRefresh: () => controller.refreshOrLoad(false),
          onLoading: () => controller.refreshOrLoad(true),
          child: Obx(() {
            return ListView.separated(
              itemCount: controller.dataList.length,
              separatorBuilder: (context, index) => Container(
                height: 10.h,
                color: Colors.black12,
              ), // item 间距
              itemBuilder: (context, index) {
                var data = controller.dataList[index];
                return _collectionItem(
                  data,
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

  Widget _collectionItem(MyCollectItemModel? item, {GestureTapCallback? onTap, GestureTapCallback? itemClick}) {
    return GestureDetector(
      onTap: itemClick,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${item?.title}",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              item?.author ?? "未知",
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "${item?.desc}",
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black54,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            Row(children: [
              Expanded(child: Text("${item?.chapterName}")),
              Text(
                "${item?.niceDate}",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 10.w),
              collectImage(true, onTap: onTap),
            ]),
          ],
        ),
      ),
    );
  }
}
