import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/pages/knowledge/details/KnowledgeDetailsViewModel.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/utils/theme_util.dart';

import '../../../repository/model/knowledge_detail_list_model.dart';
import '../../../pages/web/webview_page.dart';
import '../../../pages/web/webview_widget.dart';

/// 知识体系文章列表组件
///
/// 用于展示知识体系某个分类下的文章列表
/// 支持下拉刷新和上拉加载更多
/// 当没有更多数据时，显示"没有更多数据"提示
class DetailList extends StatefulWidget {
  /// 分类 ID，用于请求对应分类的文章列表
  final String? id;

  const DetailList({super.key, this.id});

  @override
  State<DetailList> createState() {
    return _DetailListState();
  }
}

class _DetailListState extends State<DetailList> {
  /// 视图模型，管理文章列表数据和分页状态
  var model = KnowledgeDetailsViewModel();

  /// 刷新控制器，管理下拉刷新和上拉加载状态
  late RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController(initialRefresh: false);
    super.initState();
    // 页面初始化时加载第一页数据
    refreshOrLoad(false);
  }

  /// 刷新或加载更多数据
  ///
  /// [loadMore] true 表示加载更多，false 表示刷新
  /// 根据 hasMore 状态控制是否允许加载更多
  /// 加载完成后更新 RefreshController 状态
  void refreshOrLoad(bool loadMore) {
    if (loadMore && !model.hasMore) {
      _refreshController.loadNoData();
      return;
    }
    model.getDetailList(widget.id, loadMore).then((value) {
      if (loadMore) {
        if (model.hasMore) {
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }
      } else {
        _refreshController.refreshCompleted();
        if (!model.hasMore) {
          _refreshController.loadNoData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return ChangeNotifierProvider(
      create: (context) {
        return model;
      },
      child: Scaffold(
          backgroundColor: isDark ? Colours.dark_bg_color : Colours.bg_color,
          body: Consumer<KnowledgeDetailsViewModel>(builder: (context, value, child) {
            return _buildRefreshList(value);
          })),
    );
  }

  /// 构建带刷新功能的列表
  ///
  /// 包含下拉刷新 Header 和上拉加载 Footer
  /// 支持国际化文本显示
  Widget _buildRefreshList(KnowledgeDetailsViewModel value) {
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
        textStyle: TextStyle(color: Colours.app_main),
        idleIcon: Icon(Icons.arrow_downward, color: Colours.app_main),
        refreshingIcon: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colours.app_main),
        ),
      ),
      footer: ClassicFooter(
        loadingText: AppStrings.getString('loading'),
        canLoadingText: AppStrings.getString('release_load'),
        idleText: AppStrings.getString('pull_up_load_more'),
        noDataText: AppStrings.getString('no_more_data'),
        failedText: AppStrings.getString('load_failed'),
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
          return _buildListItem(
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
  }

  /// 构建文章列表项
  ///
  /// [item] 文章数据模型
  /// [onTap] 点击回调，跳转到文章详情页
  /// 显示文章标题、作者和发布时间
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

  /// 构建文章标题
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

  /// 构建文章底部信息（作者和发布时间）
  Widget _buildItemFooter(KnowledgeDetailItem item) {
    final isDark = context.isDark;
    return Container(
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
              color: isDark ? Colours.dark_text_gray : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
