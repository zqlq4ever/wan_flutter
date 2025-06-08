import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/pages/home/home_view_model.dart';
import 'package:wan_android_flutter/route/RouteUtils.dart';

import '../../repository/model/home_list_model.dart';
import '../../widgets/banner/home_banner_widget.dart';
import '../../widgets/common_styles.dart';
import '../../widgets/web/webview_page.dart';
import '../../widgets/web/webview_widget.dart';

/// 首页文章列表页面
class HomeListPage extends StatefulWidget {
  const HomeListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeListPageState();
  }
}

class _HomeListPageState extends State<HomeListPage> {
  var model = HomeViewModel();
  BannerController? bannerController = BannerController();
  late RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
    model.initDataList(false);
  }

  void refreshOrLoad(bool loadMore) {
    model.initDataList(loadMore, complete: (loadMore) {
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
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              controller: _refreshController,
              onLoading: () {
                refreshOrLoad(true);
              },
              onRefresh: () {
                refreshOrLoad(false);
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    BannerWidget(
                      controller: bannerController,
                      itemClick: (title, url) {
                        //进入网页
                        RouteUtil.push(
                          context,
                          WebViewPage(loadResource: url, webViewType: WebViewType.URL, showTitle: true, title: title),
                        );
                      },
                    ),
                    Consumer<HomeViewModel>(builder: (context, value, child) {
                      return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: value.listData?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            HomeListItemData? item = value.listData?[index];
                            return _listItem(
                                item: item,
                                onItemClick: () {
                                  //进入网页
                                  RouteUtil.push(
                                    context,
                                    WebViewPage(
                                        loadResource: item?.link ?? "",
                                        webViewType: WebViewType.URL,
                                        showTitle: true,
                                        title: item?.title),
                                  );
                                },
                                imageClick: () {
                                  if (item?.collect == true) {
                                    //取消收藏
                                    model.cancelCollect(index, "${item?.id}");
                                  } else {
                                    //收藏
                                    model.collect(index, "${item?.id}");
                                  }
                                });
                          });
                    })
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 列表 item
  Widget _listItem({
    HomeListItemData? item,
    GestureTapCallback? onItemClick,
    GestureTapCallback? imageClick,
  }) {
    int randomNumber = Random().nextInt(10000);
    String imageUrl = 'https://picsum.photos/300/400?random=$randomNumber';
    String? name = TextUtil.isEmpty(item?.author) ? item?.shareUser : item?.author;
    return GestureDetector(
      onTap: onItemClick,
      child: Card(
        margin: EdgeInsets.only(bottom: 16.h),
        color: Colors.white,
        elevation: 1,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(15.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      imageUrl,
                      width: 25,
                      height: 25,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  normalText(name ?? ""),
                  const Expanded(child: SizedBox()),
                  normalText(item?.niceShareDate),
                  SizedBox(width: 10.w),
                  Text(
                    item?.type == 1 ? "置顶" : "",
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent,
                    ),
                  )
                ],
              ),
              SizedBox(height: 5.h),
              Text(
                item?.title ?? "",
                style: titleTextStyle15,
              ),
              SizedBox(height: 5.h),
              Row(children: [
                Text(
                  "${item?.superChapterName ?? ""} . ${item?.chapterName ?? ""}",
                  style: TextStyle(fontSize: 13.sp, color: Colors.green),
                ),
                const Expanded(child: SizedBox()),
                collectImage(item?.collect, onTap: imageClick)
              ])
            ],
          ),
        ),
      ),
    );
  }
}
