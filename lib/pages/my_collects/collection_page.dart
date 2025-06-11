import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/pages/my_collects/collection_viewmodel.dart';
import 'package:wan_android_flutter/repository/model/my_collects_model.dart';

import '../../widgets/common_styles.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/web/webview_page.dart';
import '../../widgets/web/webview_widget.dart';

/// 我的收藏页面
class MyCollectsPage extends GetView<CollectionViewmodel> {
  const MyCollectsPage({super.key});

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
            return ListView.builder(
              itemCount: controller.dataList.length ?? 0,
              itemBuilder: (context, index) {
                var data = controller.dataList[index];
                return _collectItem(
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
                          showTitle: true,
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

  Widget _collectItem(MyCollectItemModel? item, {GestureTapCallback? onTap, GestureTapCallback? itemClick}) {
    return GestureDetector(
      onTap: itemClick,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Text(
                  "${item?.author}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ),
              Text(
                "${item?.niceDate}",
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              )
            ]),
            SizedBox(height: 10.h),
            Text(
              "${item?.title}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "${item?.desc}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            Row(children: [
              Expanded(child: Text("${item?.chapterName}")),
              collectImage(true, onTap: onTap),
            ]),
          ],
        ),
      ),
    );
  }
}
