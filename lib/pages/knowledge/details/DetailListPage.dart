import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/pages/knowledge/details/KnowledgeDetailsViewModel.dart';
import 'package:wan_android_flutter/res/colors.dart';

import '../../../repository/model/knowledge_detail_list_model.dart';
import '../../../widgets/web/webview_page.dart';
import '../../../widgets/web/webview_widget.dart';

/// 知识体系明细列表
class DetailListPage extends StatefulWidget {
  final String? id;

  const DetailListPage({super.key, this.id});

  @override
  State<StatefulWidget> createState() {
    return _DetailListPageState();
  }
}

class _DetailListPageState extends State<DetailListPage> {
  var model = KnowledgeDetailsViewModel();
  late RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
    refreshOrLoad(false);
  }

  void refreshOrLoad(bool loadMore) {
    model.getDetailList(widget.id, loadMore).then((value) {
      if (loadMore) {
        _refreshController.loadComplete();
      } else {
        _refreshController.refreshCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return model;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Consumer<KnowledgeDetailsViewModel>(builder: (context, value, child) {
            return SmartRefresher(
              controller: _refreshController,
              onRefresh: () {
                refreshOrLoad(false);
              },
              onLoading: () {
                refreshOrLoad(true);
              },
              child: ListView.builder(
                itemCount: value.detailList.length,
                itemBuilder: (context, index) {
                  return _item(
                    value.detailList[index],
                    onTap: () {
                      Get.to(
                        WebViewPage(
                            loadResource: value.detailList[index].link ?? "",
                            webViewType: WebViewType.URL,
                            title: value.detailList[index].title),
                      );
                    },
                  );
                },
              ),
            );
          })),
    );
  }

  Widget _item(KnowledgeDetailItem item, {GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(32.w),
        padding: EdgeInsets.all(32.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.black12,
            width: 1.r,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${item.title}", style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 32.h),
            Row(
              children: [
                Text("${item.shareUser}", style: TextStyle(fontSize: 28.sp, color: Colours.app_main)),
                const Expanded(child: SizedBox()),
                Text("${item.niceShareDate}", style: TextStyle(fontSize: 28.sp, color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
