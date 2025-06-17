import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/pages/knowledge/details/KnowledgeDetailsViewModel.dart';

import '../../../repository/model/knowledge_detail_list_model.dart';
import '../../../widgets/common_styles.dart';
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
                            showTitle: true,
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
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: Colors.black12,
            width: 0.5.r,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${item.title}", style: titleTextStyle15),
            SizedBox(height: 16.h),
            Row(
              children: [
                Text("${item.shareUser}", style: tealTextStyle14),
                const Expanded(child: SizedBox()),
                Text("${item.niceShareDate}", style: greyTextStyle14),
              ],
            )
          ],
        ),
      ),
    );
  }
}
