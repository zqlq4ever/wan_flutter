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
  State<DetailListPage> createState() {
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
          backgroundColor: Colours.bg_color,
          body: Consumer<KnowledgeDetailsViewModel>(builder: (context, value, child) {
            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: const ClassicHeader(
                idleText: '下拉刷新',
                releaseText: '释放刷新',
                refreshingText: '刷新中...',
                completeText: '刷新完成',
                failedText: '刷新失败',
                completeDuration: Duration(milliseconds: 100),
                textStyle: TextStyle(color: Colours.app_main),
                idleIcon: Icon(Icons.arrow_downward, color: Colours.app_main),
                refreshingIcon: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main),
                ),
              ),
              footer: const ClassicFooter(
                loadingText: '加载中...',
                canLoadingText: '释放加载',
                idleText: '上拉加载更多',
                noDataText: '没有更多数据',
                failedText: '加载失败',
                textStyle: TextStyle(color: Colours.app_main),
                loadingIcon: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main),
                ),
              ),
              onRefresh: () {
                refreshOrLoad(false);
              },
              onLoading: () {
                refreshOrLoad(true);
              },
              child: ListView.builder(
                padding: EdgeInsets.all(24.w),
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
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(28.w, 28.w, 28.w, 0),
              child: Text(
                item.title ?? "",
                style: TextStyle(
                  fontSize: 38.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.5,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.fromLTRB(28.w, 0, 28.w, 28.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colours.app_main.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      item.shareUser ?? "",
                      style: TextStyle(
                        fontSize: 30.sp,
                        color: Colours.app_main,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    item.niceShareDate ?? "",
                    style: TextStyle(
                      fontSize: 30.sp,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
