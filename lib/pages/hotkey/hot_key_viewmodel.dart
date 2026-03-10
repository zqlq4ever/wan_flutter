import 'package:get/get.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';

import '../../repository/model/common_website_model.dart';
import '../../repository/model/search_hot_key_model.dart';

class HotKeyViewModel extends GetxController {
  final _hotKeyList = <SearchHotKeyModel>[].obs;
  final _websiteList = <CommonWebsiteModel>[].obs;
  final _isLoading = false.obs;
  final _hasError = false.obs;

  List<SearchHotKeyModel> get hotKeyList => _hotKeyList;

  List<CommonWebsiteModel> get websiteList => _websiteList;

  bool get isLoading => _isLoading.value;

  bool get hasError => _hasError.value;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    _isLoading.value = true;
    _hasError.value = false;

    try {
      final results = await Future.wait<dynamic>([
        _getHotKeyList(),
        _getCommonWebsiteList(),
      ]);
      _hotKeyList.assignAll(results[0] as List<SearchHotKeyModel>);
      _websiteList.assignAll(results[1] as List<CommonWebsiteModel>);
    } catch (e) {
      _hasError.value = true;
    } finally {
      _isLoading.value = false;
    }
  }

  Future<List<SearchHotKeyModel>> _getHotKeyList() async {
    final list = await WanApi.instance.searchHotKeys();
    return list ?? [];
  }

  Future<List<CommonWebsiteModel>> _getCommonWebsiteList() async {
    final list = await WanApi.instance.commonWebsiteList();
    return list ?? [];
  }
}
