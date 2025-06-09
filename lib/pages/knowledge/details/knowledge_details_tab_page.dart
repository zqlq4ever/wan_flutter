import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/pages/knowledge/details/detail_tab_child_page.dart';

import '../../../repository/model/knowledge_detail_param.dart';
import 'knowledge_details_view_model.dart';

/// 知识体系明细 tab 指示器页面
class KnowledgeDetailsTabPage extends StatefulWidget {
  final List<KnowledgeDetailParam>? params;

  const KnowledgeDetailsTabPage({super.key, this.params});

  @override
  State<StatefulWidget> createState() {
    return _KnowledgeDetailsTabPageState();
  }
}

class _KnowledgeDetailsTabPageState extends State<KnowledgeDetailsTabPage> with SingleTickerProviderStateMixin {
  var model = KnowledgeDetailsViewModel();
  TabController? controller;
  var paras = Get.arguments as List<KnowledgeDetailParam>;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: paras.length, vsync: this);
    model.initTabs(paras);
    log("KnowledgeDetailsPage params=${paras.length}");
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return model;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TabBar(
            dividerHeight: 0,
            controller: controller,
            tabs: model.tabList,
            isScrollable: true,
            labelColor: Colors.deepOrange,
            indicatorColor: Colors.green,
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: controller,
            children: children(),
          ),
        ),
      ),
    );
  }

  /// 根据传进来的数据生成对应数量的tabPage
  List<Widget> children() {
    return paras.map((e) {
      return DetailTabChildPage(id: e.id);
    }).toList();
  }
}
