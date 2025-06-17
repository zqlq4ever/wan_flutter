import 'dart:developer';

import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../repository/api/wan_api.dart';
import '../../repository/model/my_collects_model.dart';

class CollectionViewModel extends GetxController {
  late RefreshController refreshController;
  var dataList = <MyCollectItemModel>[].obs;
  int _pageCount = 0;

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(initialRefresh: false);
    refreshOrLoad(false);
  }

  void refreshOrLoad(bool loadMore) {
    getMyCollection(loadMore).then((value) {
      if (loadMore) {
        refreshController.loadComplete();
        return;
      }

      refreshController.refreshCompleted();
    });
  }

  /// 获取我的收藏列表
  Future getMyCollection(bool loadMore) async {
    if (loadMore) {
      _pageCount++;
    } else {
      _pageCount = 0;
      dataList.clear();
    }

    var list = await WanApi.instance.getMyCollects("$_pageCount");
    if (list != null && list.isNotEmpty == true) {
      dataList.addAll(list);
      return;
    }

    if (loadMore && _pageCount > 0) {
      _pageCount--;
    }
  }

  /// 取消收藏文章
  Future cancelCollect(
    int index,
    String? id,
    String? originId,
  ) async {
    bool success = await WanApi.instance.cancelCollect2(id ?? "", originId ?? "-1");
    if (success) {
      try {
        dataList.remove(dataList[index]);
      } catch (e) {
        log("cancelCollect error=$e");
      }
    }
  }
}
