import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/home/home_list_page.dart';
import 'package:wan_android_flutter/pages/hotkey/hot_key_page.dart';
import 'package:wan_android_flutter/pages/knowledge/knowledge_page.dart';
import 'package:wan_android_flutter/pages/knowledge/knowledge_view_model.dart';
import 'package:wan_android_flutter/pages/mine/mine_page.dart';

import '../widgets/navigation/navigation_bar_widget.dart';
import 'home/home_view_model.dart';

class HomeBottomTab extends StatefulWidget {
  const HomeBottomTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BottomTabState();
  }
}

class _BottomTabState extends State<HomeBottomTab> {
  final List<Widget> tabItems = [];
  final List<String> tabLabels = ["首页", "热点", "体系", "我的"];
  final List<String> tabIcons = [
    "assets/images/icon_home_grey.png",
    "assets/images/icon_hot_key_grey.png",
    "assets/images/icon_knowledge_grey.png",
    "assets/images/icon_mine_grey.png"
  ];

  final List<String> tabActiveIcons = [
    "assets/images/icon_home_selected.png",
    "assets/images/icon_hot_key_selected.png",
    "assets/images/icon_knowledge_selected.png",
    "assets/images/icon_mine_selected.png"
  ];

  @override
  void initState() {
    super.initState();
    initTabPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      extendBody: true,
      backgroundColor: Colors.white,
      body: NavigationBarWidget(
        tabItems: tabItems,
        tabLabels: tabLabels,
        tabIcons: tabIcons,
        tabActiveIcons: tabActiveIcons,
      ),
    );
  }

  void initTabPage() {
    tabItems.add(const HomeListPage());
    tabItems.add(const HotKeyPage());
    tabItems.add(const KnowledgePage());
    tabItems.add(const MineNewPage());

    Get.lazyPut(() => HomeViewModel());
    Get.lazyPut(() => KnowledgeViewModel());
  }
}
