import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/knowledge/details/DetailList.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/utils/theme_util.dart';

import '../../../repository/model/knowledge_detail_param.dart';
import '../../../widgets/my_app_bar.dart';
import 'KnowledgeDetailsViewModel.dart';

class KnowledgeDetailsPage extends StatefulWidget {
  final List<KnowledgeDetailParam>? params;

  const KnowledgeDetailsPage({super.key, this.params});

  @override
  State<StatefulWidget> createState() {
    return _KnowledgeDetailsPageState();
  }
}

class _KnowledgeDetailsPageState extends State<KnowledgeDetailsPage>
    with SingleTickerProviderStateMixin {
  final vm = Get.put(KnowledgeDetailsViewModel());
  TabController? tabController;
  late List<KnowledgeDetailParam> paras;

  @override
  void initState() {
    super.initState();
    paras = Get.arguments as List<KnowledgeDetailParam>;
    tabController = TabController(length: paras.length, vsync: this);
    vm.initTabs(paras);
  }

  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Scaffold(
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
    );
  }

  Widget _buildTabBar() {
    final isDark = context.isDark;
    final primaryColor = Theme.of(context).primaryColor;
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
                color: primaryColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              indicatorPadding: EdgeInsets.zero,
              labelPadding:
                  EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
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
              unselectedLabelColor: primaryColor,
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

  List<Widget> _buildTabBarViews() {
    return paras.map((e) {
      return DetailList(id: e.id);
    }).toList();
  }
}
