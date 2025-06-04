import 'package:flutter/material.dart';
import 'package:wan_android_flutter/pages/home/home_list_page.dart';
import 'package:wan_android_flutter/pages/hot/hot_key_page.dart';
import 'package:wan_android_flutter/pages/knowledge/knowledge_page.dart';
import 'package:wan_android_flutter/pages/mine/mine_page.dart';

import '../widgets/navigation/navigation_bar_widget.dart';

class BottomTabPage extends StatefulWidget {
  const BottomTabPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BottomTabState();
  }
}

class _BottomTabState extends State<BottomTabPage> {
  final List<Widget> tabItems = [];
  final List<String> tabLabels = ["首页", "热点", "体系", "我的"];
  final List<String> tabIcons = [
    "assets/images/icon_home_grey.png",
    "assets/images/icon_hot_key_grey.png",
    "assets/images/icon_knowledge_grey.png",
    "assets/images/icon_personal_grey.png"
  ];

  final List<String> tabActiveIcons = [
    "assets/images/icon_home_selected.png",
    "assets/images/icon_hot_key_selected.png",
    "assets/images/icon_knowledge_selected.png",
    "assets/images/icon_personal_selected.png"
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
    tabItems.add(const MinePage());
  }
}
