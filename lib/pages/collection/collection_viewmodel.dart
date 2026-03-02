import 'dart:developer';

import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../repository/api/wan_api.dart';
import '../../repository/model/my_collects_model.dart';
import '../../utils/sp_util.dart';
import '../../constants.dart';
import '../../route/route_path_constant.dart';

class CollectionViewModel extends GetxController {
  late RefreshController refreshController;
  var dataList = <MyCollectItemModel>[].obs;
  int _pageCount = 0;
  var hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(initialRefresh: false);
    
    // 检查用户是否已登录
    _checkLoginStatus();
  }
  
  /// 检查登录状态
  Future<void> _checkLoginStatus() async {
    String? userName = await SpUtil.getString(Constants.spUserName);
    if (userName == null || userName.isEmpty) {
      // 未登录，跳转到登录页面
      Get.toNamed(RoutePath.login);
      return;
    }
    
    refreshOrLoad(false);
  }

  void refreshOrLoad(bool loadMore) {
    if (loadMore && !hasMore.value) {
      refreshController.loadNoData();
      return;
    }
    getMyCollection(loadMore).then((hasMoreResult) {
      if (loadMore) {
        if (hasMoreResult) {
          refreshController.loadComplete();
        } else {
          refreshController.loadNoData();
        }
      } else {
        refreshController.refreshCompleted();
        if (!hasMoreResult) {
          refreshController.loadNoData();
        }
      }
    });
  }

  /// 获取我的收藏列表
  Future<bool> getMyCollection(bool loadMore) async {
    if (loadMore) {
      _pageCount++;
    } else {
      _pageCount = 0;
      dataList.clear();
      hasMore.value = true;
    }

    var model = await WanApi.instance.getMyCollects(_pageCount);
    if (model?.datas?.isNotEmpty == true) {
      dataList.addAll(model!.datas!);
      hasMore.value = !(model.over ?? true);
      return hasMore.value;
    }

    if (loadMore && _pageCount > 0) {
      _pageCount--;
    }
    hasMore.value = false;
    return false;
  }

  /// 取消收藏文章
  Future cancelCollect(
    int index,
    String? id,
    String? originId,
  ) async {
    bool success = await WanApi.instance.cancelCollectFromMyList(id ?? "", originId ?? "-1");
    if (success) {
      try {
        dataList.remove(dataList[index]);
      } catch (e) {
        log("cancelCollect error=$e");
      }
    }
  }
}
