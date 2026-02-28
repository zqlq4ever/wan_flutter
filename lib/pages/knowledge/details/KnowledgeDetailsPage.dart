import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/pages/knowledge/details/DetailListPage.dart';
import 'package:wan_android_flutter/res/colors.dart';

import '../../../repository/model/knowledge_detail_param.dart';
import '../../../widgets/my_app_bar.dart';
import 'KnowledgeDetailsViewModel.dart';

/// 知识体系子页面
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
  var vm = KnowledgeDetailsViewModel();
  TabController? tabController;
  var paras = Get.arguments as List<KnowledgeDetailParam>;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: paras.length, vsync: this);
    vm.initTabs(paras);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return vm;
      },
      child: Scaffold(
        backgroundColor: Colours.bg_color,
        appBar: MyAppBar(
          centerTitle: paras.isNotEmpty ? (paras.first.name ?? "知识体系") : "知识体系",
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: 80.h,
                  child: TabBar(
                    dividerHeight: 0,
                    tabAlignment: TabAlignment.start,
                    indicatorSize: TabBarIndicatorSize.label,
                    isScrollable: true,
                    indicator: BoxDecoration(
                      color: Colours.app_main,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    // 增加 vertical padding 确保背景框完全包裹文字
                    indicatorPadding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    labelPadding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 8.h), // 增加 vertical padding
                    labelStyle: TextStyle(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2, // 增加行高确保文字不贴边
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.normal,
                      height: 1.2,
                    ),
                    controller: tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colours.app_main,
                    overlayColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        return Colors.transparent;
                      },
                    ),
                    // 移除水平 padding 让 tabBar 可以从屏幕边缘开始
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    tabs: vm.tabList,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: TabBarView(
                controller: tabController,
                physics: const ClampingScrollPhysics(),
                children: children(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> children() {
    return paras.map((e) {
      return DetailListPage(id: e.id);
    }).toList();
  }
}
