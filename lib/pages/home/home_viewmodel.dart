import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';
import 'package:wan_android_flutter/repository/model/home_list_model.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/widgets/banner/banner_controller.dart';

class HomeViewModel extends GetxController {
  final BannerController bannerController = BannerController();
  late final RefreshController refreshController;
  
  final _listData = <HomeListItemData>[].obs;
  List<HomeListItemData> get listData => _listData;
  
  int _pageCount = 0;
  
  final _currentUrl = "https://picsum.photos/400/200".obs;
  String get currentUrl => _currentUrl.value;
  
  final _hasMore = true.obs;
  bool get hasMore => _hasMore.value;

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(initialRefresh: false);
    bannerController.setIndexChangeListener((url) {
      _currentUrl.value = url;
    });
    initDataList(false);
  }

  @override
  void onClose() {
    refreshController.dispose();
    bannerController.dispose();
    super.onClose();
  }

  void refreshOrLoad(bool loadMore) {
    if (loadMore && !_hasMore.value) {
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

  Future<void> initDataList(bool loadMore, {ValueChanged<bool>? complete}) async {
    if (loadMore) {
      _pageCount++;
    } else {
      _pageCount = 0;
      _listData.clear();
      _hasMore.value = true;
    }

    _getHomeList(loadMore).then((result) {
      _listData.addAll(result.$1 ?? []);
      _hasMore.value = result.$2;
      complete?.call(result.$2);
      update();
    });
  }

  Future<(List<HomeListItemData>?, bool)> _getHomeList(bool loadMore) async {
    try {
      HomeListModel? data = await WanApi.instance.homeList(_pageCount);
      if (data != null && data.datas?.isNotEmpty == true) {
        return (data.datas, !(data.over ?? true));
      } else {
        if (loadMore && _pageCount > 0) {
          _pageCount--;
        }
        return (null, false);
      }
    } catch (e) {
      if (loadMore && _pageCount > 0) {
        _pageCount--;
      }
      showToast(AppStrings.getString('network_error'));
      return (null, false);
    }
  }

  Future<void> collect(int index, String? id) async {
    try {
      bool success = await WanApi.instance.collect(id ?? "");
      if (success && index >= 0 && index < _listData.length) {
        _listData[index].collect = true;
        update([id ?? ""]);
      }
    } catch (e) {
      showToast(AppStrings.getString('network_error'));
    }
  }

  Future<void> cancelCollect(int index, String? id) async {
    try {
      bool success = await WanApi.instance.cancelCollect(id ?? "");
      if (success && index >= 0 && index < _listData.length) {
        _listData[index].collect = false;
        update([id ?? ""]);
      }
    } catch (e) {
      showToast(AppStrings.getString('network_error'));
    }
  }
}
