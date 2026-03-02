import 'package:flutter/material.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';

import '../../../repository/model/knowledge_detail_list_model.dart';
import '../../../repository/model/knowledge_detail_param.dart';

/// 知识体系业务逻辑层
class KnowledgeDetailsViewModel with ChangeNotifier {
  List<Tab> tabList = [];

  List<KnowledgeDetailItem> detailList = [];

  int _pageCount = 0;

  bool hasMore = true;

  /// 初始化 tab 列表
  void initTabs(List<KnowledgeDetailParam>? params) {
    if (params?.isNotEmpty == true) {
      params?.forEach((item) {
        tabList.add(Tab(text: item.name ?? ""));
      });
    }
  }

  /// 知识体系明细列表数据
  Future<bool> getDetailList(String? id, bool loadMore) async {
    if (loadMore) {
      _pageCount++;
    } else {
      _pageCount = 0;
      detailList.clear();
      hasMore = true;
    }
    var model = await WanApi.instance.knowledgeDetailList(id ?? "", _pageCount);
    if (model?.datas?.isNotEmpty == true) {
      detailList.addAll(model!.datas!);
      hasMore = !(model.over ?? true);
      notifyListeners();
      return true;
    } else {
      if (loadMore && _pageCount > 0) {
        _pageCount--;
      }
      hasMore = false;
      notifyListeners();
      return false;
    }
  }
}
