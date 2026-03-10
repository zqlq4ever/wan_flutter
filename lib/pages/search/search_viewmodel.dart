import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';

import '../../repository/model/search_list_model.dart';

class SearchViewModel extends GetxController {
  late TextEditingController editController;
  Worker? _debounceWorker;

  final _dataList = <SearchListItemModel>[].obs;
  List<SearchListItemModel> get dataList => _dataList;

  final _hasText = false.obs;
  RxBool get hasText => _hasText;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _hasError = false.obs;
  bool get hasError => _hasError.value;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    final keyword = args?["keyword"] ?? "";

    editController = TextEditingController(text: keyword);
    _hasText.value = keyword.isNotEmpty;

    _debounceWorker = debounce(
      _hasText,
      (_) => _onSearchChanged(),
      time: const Duration(milliseconds: 500),
    );

    if (keyword.isNotEmpty) {
      searchList(keyword);
    } else {
      searchList();
    }
  }

  @override
  void onClose() {
    _debounceWorker?.dispose();
    editController.dispose();
    super.onClose();
  }

  void onInputChanged(String value) {
    _hasText.value = value.isNotEmpty;
    if (value.isEmpty) {
      searchList();
    }
  }

  void _onSearchChanged() {
    final input = editController.text.trim();
    if (input.isNotEmpty) {
      searchList(input);
    }
  }

  Future<void> searchList([String? keyword]) async {
    _isLoading.value = true;
    _hasError.value = false;

    try {
      final list = await WanApi.instance.search(keyword?.trim() ?? "");
      _dataList.assignAll(list);
    } catch (e) {
      _hasError.value = true;
      _dataList.clear();
    } finally {
      _isLoading.value = false;
    }
  }

  void clearInput() {
    editController.clear();
    _hasText.value = false;
    searchList();
  }
}
