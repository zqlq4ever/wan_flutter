import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';
import 'package:wan_android_flutter/res/app_strings.dart';

import '../../../repository/model/knowledge_detail_list_model.dart';
import '../../../repository/model/knowledge_detail_param.dart';

class KnowledgeDetailsViewModel extends GetxController {
  final _tabList = <Tab>[].obs;
  final _detailList = <KnowledgeDetailItem>[].obs;
  final _hasMore = true.obs;
  final _isLoading = false.obs;

  List<Tab> get tabList => _tabList;
  List<KnowledgeDetailItem> get detailList => _detailList;
  bool get hasMore => _hasMore.value;
  bool get isLoading => _isLoading.value;

  int _pageCount = 0;

  void initTabs(List<KnowledgeDetailParam>? params) {
    if (params == null || params.isEmpty) return;
    _tabList.assignAll(
      params.map((item) => Tab(text: item.name ?? "")).toList(),
    );
  }

  Future<bool> getDetailList(String? id, bool loadMore) async {
    if (loadMore && !_hasMore.value) return false;

    if (loadMore) {
      _pageCount++;
    } else {
      _pageCount = 0;
      _detailList.clear();
      _hasMore.value = true;
    }

    _isLoading.value = true;
    try {
      final model =
          await WanApi.instance.knowledgeDetailList(id ?? "", _pageCount);
      if (model?.datas?.isNotEmpty == true) {
        _detailList.addAll(model!.datas!);
        _hasMore.value = !(model.over ?? true);
        return true;
      } else {
        if (loadMore && _pageCount > 0) _pageCount--;
        _hasMore.value = false;
        return false;
      }
    } catch (e) {
      if (loadMore && _pageCount > 0) _pageCount--;
      _hasMore.value = false;
      showToast(AppStrings.getString('network_error'));
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}
