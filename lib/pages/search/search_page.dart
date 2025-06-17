import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/pages/search/search_viewmodel.dart';
import 'package:wan_android_flutter/repository/model/search_list_model.dart';

import '../../res/colors.dart';
import '../../widgets/common_styles.dart';
import '../../widgets/web/webview_page.dart';
import '../../widgets/web/webview_widget.dart';

/// 搜索页
class SearchPage extends GetView<SearchViewModel> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _searchBar(
              onTapReset: () {
                //  清空
                controller.editController.text = "";
                controller.searchList();
              },
            ),
            _searchListWidget(
              onItemTap: (item) {
                Get.to(
                  WebViewPage(
                    loadResource: item?.link ?? "",
                    title: item?.title,
                    webViewType: WebViewType.URL,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _searchBar({
    GestureTapCallback? onTapReset,
  }) {
    return Container(
        color: Colors.white,
        height: 50.h,
        child: Row(children: [
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: () => Get.back(),
            child: Image.asset(
              "assets/images/icon_back.png",
              width: 20.r,
              height: 20.r,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              child: TextField(
                cursorColor: Colours.app_main,
                textAlign: TextAlign.justify,
                controller: controller.editController,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w300,
                ),
                decoration: _inputDecoration(),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: onTapReset,
            child: Text("重置", style: titleTextStyle15),
          ),
          SizedBox(width: 15.w)
        ]));
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.white),
      borderRadius: BorderRadius.all(Radius.circular(8.r)),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.only(left: 10.w, right: 10.w),
      fillColor: Colours.line,
      filled: true,
      enabledBorder: _inputBorder(),
      focusedBorder: _inputBorder(),
      border: _inputBorder(),
    );
  }

  Widget _searchListWidget({
    required ValueChanged<SearchListItemModel?> onItemTap,
  }) {
    var list = controller.dataList;
    return Obx(() {
      return Expanded(
        child: ListView.separated(
          itemCount: list.length,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(color: Colours.text_gray_c);
          },
          itemBuilder: (context, index) {
            var item = list[index];
            return GestureDetector(
              onTap: () => onItemTap.call(item),
              child: Container(
                alignment: Alignment.centerLeft,
                width: double.infinity,
                child: Row(
                  children: [
                    Text(
                      "$index",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colours.app_main,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Html(
                        data: item.title?.trim() ?? "",
                        style: {
                          //  整体样式使用 html
                          "html": Style(
                            fontSize: FontSize(15.sp),
                            color: Colors.black87,
                          )
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
