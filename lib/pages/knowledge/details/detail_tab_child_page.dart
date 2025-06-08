import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/pages/knowledge/details/knowledge_details_view_model.dart';

import '../../../repository/model/knowledge_detail_list_model.dart';
import '../../../route/RouteUtils.dart';
import '../../../widgets/common_styles.dart';
import '../../../widgets/web/webview_page.dart';
import '../../../widgets/web/webview_widget.dart';

/// 知识体系明细 tab 页签页面
class DetailTabChildPage extends StatefulWidget {
  final String? id;

  const DetailTabChildPage({super.key, this.id});

  @override
  State<StatefulWidget> createState() {
    return _DetailTabChildPageState();
  }
}

class _DetailTabChildPageState extends State<DetailTabChildPage> {
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
                      return _item(value.detailList[index], onTap: () {
                        //  进入网页
                        RouteUtil.push(
                          context,
                          WebViewPage(
                              loadResource: value.detailList[index].link ?? "",
                              webViewType: WebViewType.URL,
                              showTitle: true,
                              title: value.detailList[index].title),
                        );
                      });
                    }));
          })),
    );
  }

  Widget _item(KnowledgeDetailItem item, {GestureTapCallback? onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 15.w),
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(border: Border.all(color: Colors.black12, width: 0.5.r)),
            child: Column(children: [
              Row(
                children: [
                  normalText(item.superChapterName),
                  const Expanded(child: SizedBox()),
                  Text("${item.niceShareDate}"),
                ],
              ),
              Text("${item.title}", style: titleTextStyle15),
              Row(
                children: [
                  normalText(item.chapterName),
                  const Expanded(child: SizedBox()),
                  Text("${item.shareUser}"),
                ],
              )
            ])));
  }
}
