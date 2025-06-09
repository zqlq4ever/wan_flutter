import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/pages/search/search_view_model.dart';
import 'package:wan_android_flutter/repository/model/search_list_model.dart';
import 'package:wan_android_flutter/route/RoutePath.dart';

import '../../widgets/common_styles.dart';
import '../../widgets/web/webview_page.dart';
import '../../widgets/web/webview_widget.dart';

/// 搜索页
class SearchPage extends StatefulWidget {
  final String? keyWord;

  const SearchPage({super.key, this.keyWord});

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  SearchViewModel vm = SearchViewModel();
  TextEditingController? _editController;

  @override
  void initState() {
    _editController = TextEditingController(text: widget.keyWord ?? "");
    super.initState();
    vm.searchList(widget.keyWord);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => vm,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _searchBar(
                onSubmitted: (value) {
                  if (!value.trim().isNotEmpty) {
                    showToast("输入不可以为空！");
                    return;
                  }
                  vm.searchList(value);
                },
                onTapReset: () {
                  //  清空
                  _editController?.text = "";
                  vm.searchList();
                },
                onTapFinish: () {
                  //  退出
                  Navigator.pop(context);
                },
              ),
              _searchResultsView(
                onItemTap: (item) {
                  Get.to(
                    WebViewPage(
                      loadResource: item?.link ?? "",
                      title: item?.title,
                      showTitle: true,
                      webViewType: WebViewType.URL,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar({
    ValueChanged<String>? onSubmitted,
    GestureTapCallback? onTapReset,
    GestureTapCallback? onTapFinish,
  }) {
    return Container(
        color: Colors.white,
        height: 50.h,
        child: Row(children: [
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: onTapFinish,
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
                textAlign: TextAlign.justify,
                controller: _editController,
                style: titleTextStyle15,
                decoration: _inputDecoration(),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                onSubmitted: onSubmitted,
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
      borderSide: const BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(8.r)),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.only(left: 10.w, right: 10.w),
      fillColor: Colors.white,
      filled: true,
      enabledBorder: _inputBorder(),
      focusedBorder: _inputBorder(),
      border: _inputBorder(),
    );
  }

  Widget _searchResultsView({
    ValueChanged<SearchListItemModel?>? onItemTap,
  }) {
    return Selector<SearchViewModel, List<SearchListItemModel>?>(
      selector: (context, vm) => vm.dataList,
      builder: (context, value, child) {
        return Expanded(
          child: ListView.builder(
            itemCount: value?.length ?? 0,
            itemBuilder: (context, index) {
              var item = value?[index];
              return _resultItem(item, onItemTap: () {
                onItemTap?.call(item);
              });
            },
          ),
        );
      },
    );
  }

  Widget _resultItem(
    SearchListItemModel? item, {
    GestureTapCallback? onItemTap,
  }) {
    return GestureDetector(
      onTap: onItemTap,
      child: Container(
        alignment: Alignment.centerLeft,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Html(
          data: item?.title ?? "",
          style: {
            //  整体样式使用 html
            "html": Style(
              fontSize: FontSize(15.sp),
              color: Colors.black54,
            )
          },
        ),
      ),
    );
  }
}
