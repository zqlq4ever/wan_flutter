import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';

import '../../repository/model/search_list_model.dart';

class SearchViewModel extends GetxController {
  late TextEditingController editController;
  var dataList = <SearchListItemModel>[].obs;
  var hasText = false.obs;

  @override
  void onInit() {
    super.onInit();
    //  外部传入的参数
    final args = Get.arguments as Map<String, dynamic>?;
    var k = args?["keyword"] ?? "";
    log("SearchViewModel $k");

    editController = TextEditingController(text: k);
    editController.debounce(const Duration(milliseconds: 500), _listener);

    // 初始化时延迟 1 秒
    Future.delayed(const Duration(milliseconds: 500), () {
      //  TextEditingController 只响应用户输入
      //  初始化时,手动触发一次搜索
      searchList(k);
    });
  }

  @override
  void onClose() {
    editController.removeListener(_listener);
    editController.dispose();
  }

  void _listener() {
    var input = editController.text;
    hasText.value = input.isNotEmpty;
    log("SearchViewModel _listener input = $input");
    if (!input.trim().isNotEmpty) {
      return;
    }
    searchList(input);
  }

  Future searchList([String? keyWord = ""]) async {
    List<SearchListItemModel> list = await WanApi.instance.search(keyWord ?? "");
    if (list.isNotEmpty) {
      dataList.value = list;
    }
  }

  void clearList() {
    dataList.clear();
  }
}

// 为 TextEditingController 添加防抖扩展
extension DebounceExtension on TextEditingController {
  void debounce(Duration duration, VoidCallback callback) {
    Timer? timer;
    addListener(() {
      timer?.cancel();
      timer = Timer(duration, callback);
    });
  }
}
