import 'package:flutter/material.dart';
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
      titleSpacing: 3.w,
      leading: IconButton(
        icon: Image.asset(
          "assets/images/icon_back.png",
          width: 60.r,
          height: 60.r,
        ),
        onPressed: () => Get.back(),
      ),
      title: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.grey[100]!,
          borderRadius: BorderRadius.circular(40.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        margin: EdgeInsets.only(right: 40.w),
        child: TextField(
          cursorColor: Colours.app_main,
          controller: controller.editController,
          style: TextStyle(
            color: Colors.black,
            fontSize: 40.sp,
            fontWeight: FontWeight.w300,
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              controller.hasText.value = false;
              controller.searchList();
            } else if (!controller.hasText.value) {
              controller.hasText.value = true;
            }
          },
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 32.w,
              vertical: 20.h,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            prefixIcon: Container(
              alignment: Alignment.center,
              child: Icon(Icons.search, color: Colors.grey, size: 60.r),
            ),
            prefixIconConstraints: BoxConstraints.tightFor(
              width: 60.r,
              height: 80.h,
            ),
            suffixIcon: Container(
              alignment: Alignment.center,
              child: Obx(() => Visibility(
                    visible: controller.hasText.value,
                    child: GestureDetector(
                      onTap: () {
                        controller.editController.text = "";
                        controller.hasText.value = false;
                        controller.searchList();
                      },
                      child: Icon(Icons.clear, size: 60.r, color: Colors.grey),
                    ),
                  )),
            ),
            suffixIconConstraints: BoxConstraints.tightFor(
              width: 60.r,
              height: 80.h,
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchListWidget({
    required ValueChanged<SearchListItemModel?> onItemTap,
  }) {
    var list = controller.dataList;
    return Obx(() {
      return ListView.builder(
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
              padding: EdgeInsets.all(28.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Text(
                          item.title?.trim() ?? "",
                          style: TextStyle(
                            fontSize: 44.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 56.sp,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.only(left: 56.r + 16.w),
                    child: IntrinsicWidth(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 48.sp,
                            color: Colors.grey[400],
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            item.author ?? item.shareUser ?? "匿名",
                            style: TextStyle(
                              fontSize: 30.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                          SizedBox(width: 48.w),
                          Icon(
                            Icons.access_time,
                            size: 48.sp,
                            color: Colors.grey[400],
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            item.niceDate ?? "",
                            style: TextStyle(
                              fontSize: 30.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
