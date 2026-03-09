import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';
import 'package:wan_android_flutter/repository/model/my_collects_model.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/utils/sp_util.dart';
import 'package:wan_android_flutter/constants.dart';
import 'package:wan_android_flutter/route/route_path_constant.dart';

class CollectionViewModel extends GetxController {
  late RefreshController refreshController;
  
  final _dataList = <MyCollectItemModel>[].obs;
  List<MyCollectItemModel> get dataList => _dataList;
  
  int _pageCount = 0;
  
  final _hasMore = true.obs;
  bool get hasMore => _hasMore.value;

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(initialRefresh: false);
    _checkLoginStatus();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  Future<void> _checkLoginStatus() async {
    String? userName = await SpUtil.getString(Constants.spUserName);
    if (userName == null || userName.isEmpty) {
      Get.toNamed(RoutePath.login);
      return;
    }
    refreshOrLoad(false);
  }

  void refreshOrLoad(bool loadMore) {
    if (loadMore && !_hasMore.value) {
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

  Future<bool> getMyCollection(bool loadMore) async {
    if (loadMore) {
      _pageCount++;
    } else {
      _pageCount = 0;
      _dataList.clear();
      _hasMore.value = true;
    }

    try {
      var model = await WanApi.instance.getMyCollects(_pageCount);
      if (model?.datas?.isNotEmpty == true) {
        _dataList.addAll(model!.datas!);
        _hasMore.value = !(model.over ?? true);
        return _hasMore.value;
      }

      if (loadMore && _pageCount > 0) {
        _pageCount--;
      }
      _hasMore.value = false;
      return false;
    } catch (e) {
      if (loadMore && _pageCount > 0) {
        _pageCount--;
      }
      showToast(AppStrings.getString('network_error'));
      return false;
    }
  }

  Future<void> cancelCollect(int index, String? id, String? originId) async {
    try {
      bool success = await WanApi.instance.cancelCollectFromMyList(id ?? "", originId ?? "-1");
      if (success && index >= 0 && index < _dataList.length) {
        _dataList.removeAt(index);
      }
    } catch (e) {
      showToast(AppStrings.getString('network_error'));
    }
  }
}
