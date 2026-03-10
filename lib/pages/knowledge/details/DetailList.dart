import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/pages/knowledge/details/KnowledgeDetailsViewModel.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/utils/theme_util.dart';

import '../../../pages/web/webview_page.dart';
import '../../../pages/web/webview_widget.dart';
import '../../../repository/model/knowledge_detail_list_model.dart';

class DetailList extends StatefulWidget {
  final String? id;

  const DetailList({super.key, this.id});

  @override
  State<DetailList> createState() {
    return _DetailListState();
  }
}

class _DetailListState extends State<DetailList> {
  late final KnowledgeDetailsViewModel vm;
  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    vm = Get.put(KnowledgeDetailsViewModel(), tag: widget.id);
    _refreshController = RefreshController(initialRefresh: false);
    refreshOrLoad(false);
  }

  @override
  void dispose() {
    Get.delete<KnowledgeDetailsViewModel>(tag: widget.id);
    _refreshController.dispose();
    super.dispose();
  }

  void refreshOrLoad(bool loadMore) {
    if (loadMore && !vm.hasMore) {
      _refreshController.loadNoData();
      return;
    }
    vm.getDetailList(widget.id, loadMore).then((value) {
      if (loadMore) {
        if (vm.hasMore) {
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }
      } else {
        _refreshController.refreshCompleted();
        if (!vm.hasMore) {
          _refreshController.loadNoData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Scaffold(
      backgroundColor: isDark ? Colours.dark_bg_color : Colours.bg_color,
      body: Obx(() => _buildRefreshList()),
    );
  }

  Widget _buildRefreshList() {
    final primaryColor = Theme.of(context).primaryColor;
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      header: ClassicHeader(
        idleText: AppStrings.getString('pull_down_refresh'),
        releaseText: AppStrings.getString('release_refresh'),
        refreshingText: AppStrings.getString('refreshing'),
        completeText: AppStrings.getString('refresh_complete'),
        failedText: AppStrings.getString('refresh_failed'),
        completeDuration: Duration(milliseconds: 100),
        textStyle: TextStyle(color: primaryColor),
        idleIcon: Icon(Icons.arrow_downward, color: primaryColor),
        refreshingIcon: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      ),
      footer: ClassicFooter(
        loadingText: AppStrings.getString('loading'),
        canLoadingText: AppStrings.getString('release_load'),
        idleText: AppStrings.getString('pull_up_load_more'),
        noDataText: AppStrings.getString('no_more_data'),
        failedText: AppStrings.getString('load_failed'),
        textStyle: TextStyle(color: primaryColor),
        loadingIcon: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
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
        itemCount: vm.detailList.length,
        itemBuilder: (context, index) {
          return _buildListItem(
            vm.detailList[index],
            onTap: () {
              Get.to(
                WebViewPage(
                    loadResource: vm.detailList[index].link ?? "",
                    webViewType: WebViewType.URL,
                    title: vm.detailList[index].title),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildListItem(KnowledgeDetailItem item, {GestureTapCallback? onTap}) {
    final isDark = context.isDark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: isDark ? Colours.dark_card_bg : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItemTitle(item),
            SizedBox(height: 24.h),
            _buildItemFooter(item),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTitle(KnowledgeDetailItem item) {
    final isDark = context.isDark;
    return Padding(
      padding: EdgeInsets.fromLTRB(28.w, 28.w, 28.w, 0),
      child: Text(
        item.title ?? "",
        style: TextStyle(
          fontSize: 38.sp,
          fontWeight: FontWeight.w600,
          color: isDark ? Colours.dark_text : Colors.black87,
          height: 1.5,
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildItemFooter(KnowledgeDetailItem item) {
    final isDark = context.isDark;
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: EdgeInsets.fromLTRB(28.w, 0, 28.w, 28.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              item.shareUser ?? "",
              style: TextStyle(
                fontSize: 30.sp,
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Text(
            item.niceShareDate ?? "",
            style: TextStyle(
              fontSize: 30.sp,
              color: isDark ? Colours.dark_text_gray : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
