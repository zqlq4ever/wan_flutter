import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/pages/knowledge/details/DetailList.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/utils/theme_util.dart';

import '../../../repository/model/knowledge_detail_param.dart';
import '../../../widgets/my_app_bar.dart';
import 'KnowledgeDetailsViewModel.dart';

/// 知识体系详情页面
///
/// 展示知识体系二级分类的 Tab 列表和对应文章列表
/// 支持多个 Tab 切换，每个 Tab 对应一个文章列表
class KnowledgeDetailsPage extends StatefulWidget {
  /// 知识体系参数列表（可选，实际数据从 Get.arguments 获取）
  final List<KnowledgeDetailParam>? params;

  const KnowledgeDetailsPage({super.key, this.params});

  @override
  State<StatefulWidget> createState() {
    return _KnowledgeDetailsPageState();
  }
}

class _KnowledgeDetailsPageState extends State<KnowledgeDetailsPage>
    with SingleTickerProviderStateMixin {
  /// 视图模型，管理 Tab 数据
  var vm = KnowledgeDetailsViewModel();

  /// Tab 控制器，管理 Tab 切换
  TabController? tabController;

  /// 知识体系参数列表，从路由参数获取
  var paras = Get.arguments as List<KnowledgeDetailParam>;

  @override
  void initState() {
    super.initState();
    // 初始化 TabController，长度为参数列表数量
    tabController = TabController(length: paras.length, vsync: this);
    // 初始化 Tab 标签列表
    vm.initTabs(paras);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return ChangeNotifierProvider(
      create: (context) {
        return vm;
      },
      child: Scaffold(
        backgroundColor: isDark ? Colours.dark_bg_color : Colours.bg_color,
        appBar: MyAppBar(
          centerTitle: paras.isNotEmpty ? (paras.first.name ?? "知识体系") : "知识体系",
          backgroundColor: isDark ? Colours.dark_card_bg : Colors.white,
        ),
        body: Column(
          children: [
            _buildTabBar(),
            SizedBox(height: 20.h),
            Expanded(
              child: TabBarView(
                controller: tabController,
                physics: const ClampingScrollPhysics(),
                children: _buildTabBarViews(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建 TabBar 区域
  ///
  /// 包含白色背景容器和居中的 Tab 标签
  /// 选中状态显示绿色圆角背景
  Widget _buildTabBar() {
    final isDark = context.isDark;
    return Container(
      width: double.infinity,
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
      child: SafeArea(
        bottom: false,
        child: Center(
          child: SizedBox(
            height: 80.h,
            child: TabBar(
              dividerHeight: 0,
              tabAlignment: TabAlignment.center,
              indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: true,
              indicator: BoxDecoration(
                color: Colours.app_main,
                borderRadius: BorderRadius.circular(20.r),
              ),
              indicatorPadding: EdgeInsets.zero,
              labelPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              labelStyle: TextStyle(
                fontSize: 34.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 34.sp,
                fontWeight: FontWeight.normal,
              ),
              controller: tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colours.app_main,
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  return Colors.transparent;
                },
              ),
              padding: EdgeInsets.zero,
              tabs: vm.tabList,
            ),
          ),
        ),
      ),
    );
  }

  /// 构建 TabBarView 子页面列表
  ///
  /// 根据参数列表创建对应的文章列表页面
  /// 每个 Tab 对应一个 DetailList 组件
  List<Widget> _buildTabBarViews() {
    return paras.map((e) {
      return DetailList(id: e.id);
    }).toList();
  }
}
