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
                height: 10,
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${item?.title}",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              item?.author ?? "未知",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "${item?.desc}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
              maxLines: 4, // 最多显示6行
              overflow: TextOverflow.ellipsis, // 超出部分用省略号表示
            ),
            Row(children: [
              Expanded(child: Text("${item?.chapterName}")),
              Text(
                "${item?.niceDate}",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 10.0.w),
              collectImage(true, onTap: onTap),
            ]),
          ],
        ),
      ),
    );
  }
}
