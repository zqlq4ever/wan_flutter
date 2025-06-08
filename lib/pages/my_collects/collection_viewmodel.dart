import 'dart:developer';

import 'package:get/get.dart';

import '../../repository/api/wan_api.dart';
import '../../repository/model/my_collects_model.dart';

class CollectionViewmodel extends GetxController {
  var dataList = <MyCollectItemModel>[].obs;
  int _pageCount = 0;

  /// 获取我的收藏列表
  Future getMyCollects(bool loadMore) async {
    if (loadMore) {
      _pageCount++;
    } else {
      _pageCount = 0;
      dataList.clear();
    }
    var list = await WanApi.instance.getMyCollects("$_pageCount");
    if (list != null && list.isNotEmpty == true) {
      dataList.addAll(list);
    } else {
      if (loadMore && _pageCount > 0) {
        _pageCount--;
      }
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
        log("cancelCollect success");
        dataList.remove(dataList[index]);
      } catch (e) {
        log("cancelCollect error=$e");
      }
    }
  }
}
