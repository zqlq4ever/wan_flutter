import 'package:get/get.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';
import 'package:wan_android_flutter/repository/model/knowledge_detail_param.dart';

import '../../repository/model/knowledge_list_model.dart';

class KnowledgeViewModel extends GetxController {
  final _list = <KnowledgeModel>[].obs;
  final _isLoading = false.obs;
  final _hasError = false.obs;

  List<KnowledgeModel> get list => _list;
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
      final resp = await WanApi.instance.knowledgeList();
      if (resp != null && resp.isNotEmpty) {
        _list.assignAll(resp);
      }
    } catch (e) {
      _hasError.value = true;
    } finally {
      _isLoading.value = false;
    }
  }

  List<KnowledgeDetailParam> generalParams(List<Children?>? children) {
    if (children == null || children.isEmpty) return [];
    return children
        .map((e) => KnowledgeDetailParam(e?.name, "${e?.id}"))
        .toList();
  }
}
