import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/pages/knowledge/details/DetailListPage.dart';
import 'package:wan_android_flutter/res/colors.dart';

import '../../../repository/model/knowledge_detail_param.dart';
import '../../../widgets/round_rect_rab_indicator.dart';
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

class _KnowledgeDetailsPageState extends State<KnowledgeDetailsPage> with SingleTickerProviderStateMixin {
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
    Color themeColor = Theme.of(context).primaryColor;
    return ChangeNotifierProvider(
      create: (context) {
        return vm;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TabBar(
            dividerHeight: 0,
            tabAlignment: TabAlignment.start,
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            indicator: const RoundRectTabIndicator(
              borderSide: BorderSide(color: Colours.app_main, width: 3),
            ),
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            controller: tabController,
            indicatorWeight: 3,
            labelColor: Colours.app_main,
            unselectedLabelColor: Colors.grey,
            // 隐藏点击效果
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                return Colors.transparent;
              },
            ),
            tabs: vm.tabList,
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: tabController,
            children: children(),
          ),
        ),
      ),
    );
  }

  /// 根据传进来的数据生成对应数量的 tabPage
  List<Widget> children() {
    return paras.map((e) {
      return DetailListPage(id: e.id);
    }).toList();
  }
}
