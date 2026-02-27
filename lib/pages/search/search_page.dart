import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/search/search_viewmodel.dart';
import 'package:wan_android_flutter/repository/model/search_list_model.dart';

import '../../res/colors.dart';
import '../../widgets/web/webview_page.dart';
import '../../widgets/web/webview_widget.dart';

/// 搜索页
class SearchPage extends GetView<SearchViewModel> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: _searchListWidget(
          onItemTap: (item) {
            Get.to(
              WebViewPage(
                loadResource: item?.link ?? "",
                title: item?.title,
                webViewType: WebViewType.URL,
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Image.asset(
          "assets/images/icon_back.png",
          width: 24.r,
          height: 24.r,
        ),
        onPressed: () => Get.back(),
      ),
      title: Container(
        height: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[100]!,
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: TextField(
          cursorColor: Colours.app_main,
          textAlign: TextAlign.start,
          controller: controller.editController,
          style: TextStyle(
            color: Colors.black,
            fontSize: 30.sp,
            fontWeight: FontWeight.w300,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
              size: 24.r,
            ),
            suffixIcon: Obx(() => Visibility(
              visible: controller.hasText.value,
              child: GestureDetector(
                onTap: () {
                  controller.editController.text = "";
                  controller.hasText.value = false;
                  controller.searchList();
                },
                child: Icon(Icons.clear, size: 24.r, color: Colors.grey),
              ),
            )),
          ),
          keyboardType: TextInputType.text,
        ),
      ),
    );
  }


  Widget _searchListWidget({
    required ValueChanged<SearchListItemModel?> onItemTap,
  }) {
    var list = controller.dataList;
    return Obx(() {
      return Expanded(
        child: ListView.builder(
          itemCount: list.length,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          itemBuilder: (context, index) {
            var item = list[index];
            return GestureDetector(
              onTap: () => onItemTap.call(item),
              child: Container(
                margin: EdgeInsets.only(bottom: 20.h),
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
                child: Container(
                  padding: EdgeInsets.all(28.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56.r,
                        height: 56.r,
                        decoration: BoxDecoration(
                          color: _getRankColor(index),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            fontSize: 28.sp,
                            color: _getRankTextColor(index),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Html(
                              data: item.title?.trim() ?? "",
                              style: {
                                "html": Style(
                                  fontSize: FontSize(30.sp),
                                  color: Colors.black87,
                                  lineHeight: LineHeight(1.5),
                                )
                              },
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.article_outlined,
                                  size: 28.sp,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  item.author ?? item.shareUser ?? "匿名",
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Icon(
                                  Icons.access_time,
                                  size: 28.sp,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  item.niceDate ?? "",
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 32.sp,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Color _getRankColor(int index) {
    if (index == 0) return Colors.orange;
    if (index == 1) return Colors.grey[400]!;
    if (index == 2) return Colors.brown[300]!;
    return Colors.grey[200]!;
  }

  Color _getRankTextColor(int index) {
    if (index == 0) return Colors.white;
    if (index == 1) return Colors.white;
    if (index == 2) return Colors.white;
    return Colors.grey[600]!;
  }
}
