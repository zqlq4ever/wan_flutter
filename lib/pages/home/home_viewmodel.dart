import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../repository/api/wan_api.dart';
import '../../repository/model/home_list_model.dart';
import '../../widgets/banner/banner_controller.dart';

class HomeViewModel extends GetxController {
  final BannerController bannerController = BannerController();
  late final RefreshController refreshController;
  var listData = <HomeListItemData>[].obs;
  int _pageCount = 0;
  var currentUrl = "https://picsum.photos/400/200".obs;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    log("HomeViewModel  onInit");
    refreshController = RefreshController(initialRefresh: false);
    bannerController.setIndexChangeListener((url) {
      currentUrl.value = url;
    });
    initDataList(false);
  }

  @override
  void dispose() {
    super.dispose();
    log("HomeViewModel  dispose");
    refreshController.dispose();
  }

  void refreshOrLoad(bool loadMore) {
    if (loadMore && !hasMore.value) {
      refreshController.loadNoData();
      return;
    }
    initDataList(loadMore, complete: (hasMore) {
      if (loadMore) {
        if (hasMore) {
          refreshController.loadComplete();
        } else {
          refreshController.loadNoData();
        }
      } else {
        refreshController.refreshCompleted();
        if (!hasMore) {
          refreshController.loadNoData();
        }
      }
    });
  }

  Future initDataList(bool loadMore, {ValueChanged<bool>? complete}) async {
    if (loadMore) {
      _pageCount++;
    } else {
      _pageCount = 0;
      listData.clear();
      hasMore.value = true;
    }

    _getHomeList(loadMore).then((result) {
      listData.addAll(result.$1 ?? []);
      hasMore.value = result.$2;
      complete?.call(result.$2);
      update();
    });
  }

  /// 获取数据
  Future<(List<HomeListItemData>?, bool)> _getHomeList(bool loadMore) async {
    HomeListModel? data = await WanApi.instance.homeList(_pageCount);
    if (data != null && data.datas?.isNotEmpty == true) {
      return (data.datas, !(data.over ?? true));
    } else {
      if (loadMore && _pageCount > 0) {
        _pageCount--;
      }
      return (null, false);
    }
  }

  /// 收藏文章
  Future collect(int index, String? id) async {
    bool success = await WanApi.instance.collect(id ?? "");
    if (success) {
      listData[index].collect = true;
      update([id ?? ""]);
    }
  }

  /// 取消收藏文章
  Future cancelCollect(int index, String? id) async {
    bool success = await WanApi.instance.cancelCollect(id ?? "");
    if (success) {
      listData[index].collect = false;
      update([id ?? ""]);
    }
  }
}
