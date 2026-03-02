import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/pages/knowledge/details/DetailList.dart';
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
              width: double.infinity,
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
      return DetailList(id: e.id);
    }).toList();
  }
}
