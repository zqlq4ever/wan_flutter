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

  @override
  void onInit() {
    super.onInit();
    log("HomeViewModel  onInit");
    refreshController = RefreshController(initialRefresh: false);
    bannerController.setIndexChangeListener((url) {
      currentUrl.value = url;
      log("HomeViewModel  url   = $url");
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
    initDataList(loadMore, complete: (loadMore) {
      if (loadMore) {
        refreshController.loadComplete();
      } else {
        refreshController.refreshCompleted();
      }
    });
  }

  Future initDataList(bool loadMore, {ValueChanged<bool>? complete}) async {
    //  加载更多
    if (loadMore) {
      _pageCount++;
    } else {
      //  重置页码
      _pageCount = 0;
      //  刷新数据
      listData.clear();
    }

    _getHomeList(loadMore).then((list) {
      listData.addAll(list ?? []);
      complete?.call(loadMore);
      update();
    });
  }

  /// 获取数据
  Future<List<HomeListItemData>?> _getHomeList(bool loadMore) async {
    HomeListModel? data = await WanApi.instance.homeList("$_pageCount");
    if (data != null && data.datas?.isNotEmpty == true) {
      return data.datas;
    } else {
      //加载更多场景，拿不到数据，页码-1
      if (loadMore && _pageCount > 0) {
        _pageCount--;
      }
      return [];
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
