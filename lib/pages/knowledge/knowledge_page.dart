import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/repository/model/knowledge_list_model.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/utils/theme_util.dart';

import '../../route/route_path_constant.dart';
import 'knowledge_viewmodel.dart';

/// 知识体系页面
///
/// 展示知识体系的一级分类列表
/// 每个分类项包含分类名称和二级分类标签
/// 点击分类项跳转到详情页，展示该分类下的文章列表
class KnowledgePage extends StatefulWidget {
  const KnowledgePage({super.key});

  @override
  State<KnowledgePage> createState() => _KnowledgePageState();
}

class _KnowledgePageState extends State<KnowledgePage> {
  late KnowledgeViewModel controller;
  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    controller = Get.find<KnowledgeViewModel>();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() {
    controller.getData();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: isDark ? Colours.dark_bg_color : Colours.bg_color,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark, primaryColor),
            SizedBox(height: 20.h),
            Expanded(
              child: RefreshConfiguration(
                headerBuilder: () => ClassicHeader(
                  idleText: AppStrings.getString('pull_down_refresh'),
                  releaseText: AppStrings.getString('release_refresh'),
                  refreshingText: AppStrings.getString('refreshing'),
                  completeText: AppStrings.getString('refresh_complete'),
                  failedText: AppStrings.getString('refresh_failed'),
                  textStyle: TextStyle(color: primaryColor),
                  idleIcon: Icon(Icons.arrow_downward, color: primaryColor),
                  refreshingIcon: SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  ),
                ),
                child: Obx(() {
                  return _buildKnowledgeList(isDark, primaryColor);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建页面头部
  ///
  /// 显示"知识体系"标题，带有左侧主题色竖条装饰
  Widget _buildHeader(bool isDark, Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: isDark ? Colours.dark_card_bg : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(width: 20.w),
          Text(
            AppStrings.getString('feature_knowledge_title'),
            style: TextStyle(
              fontSize: 54.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colours.dark_text : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建知识体系列表
  ///
  /// 使用 ListView 展示所有一级分类
  Widget _buildKnowledgeList(bool isDark, Color primaryColor) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          shrinkWrap: true,
          itemCount: controller.list.length,
          itemBuilder: (context, index) {
            return _buildKnowledgeItem(
                controller.list[index], context.isDark, primaryColor);
          }),
    );
  }

  Widget _buildKnowledgeItem(
      KnowledgeModel? item, bool isDark, Color primaryColor) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          RoutePath.knowledgeDetails,
          arguments: controller.generalParams(item?.children),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: isDark ? Colours.dark_card_bg : Colors.white,
          borderRadius: BorderRadius.circular(24.r),
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
            _buildItemHeader(item, primaryColor),
            SizedBox(height: 20.h),
            _buildChildrenTags(item?.children, isDark),
          ],
        ),
      ),
    );
  }

  /// 构建分类项头部
  ///
  /// 显示一级分类名称和右侧箭头图标
  Widget _buildItemHeader(KnowledgeModel? item, Color primaryColor) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28.w, 28.w, 28.w, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item?.name ?? "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontSize: 44.sp,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 28.r,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建二级分类标签列表
  ///
  /// [children] 二级分类列表
  /// 使用 Wrap 布局展示标签，自动换行
  Widget _buildChildrenTags(List<Children?>? children, bool isDark) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28.w, 0, 28.w, 28.w),
      child: Wrap(
        spacing: 16.w,
        runSpacing: 16.h,
        children: _buildTagWidgets(children, isDark),
      ),
    );
  }

  /// 构建标签 Widget 列表
  ///
  /// [children] 二级分类列表
  /// 返回对应的标签 Widget 列表
  List<Widget> _buildTagWidgets(List<Children?>? children, bool isDark) {
    if (children == null || children.isEmpty) return [];
    return children.map((value) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isDark ? Colours.dark_item_bottom_bg : Colors.grey[50],
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
              color: isDark ? Colours.dark_divider : Colors.grey[200]!,
              width: 1),
        ),
        child: Text(
          value?.name ?? "",
          style: TextStyle(
            fontSize: 34.sp,
            color: isDark ? Colours.dark_text : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }).toList();
  }
}
