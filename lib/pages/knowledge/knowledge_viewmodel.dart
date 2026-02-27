import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';
import 'package:wan_android_flutter/repository/model/knowledge_detail_param.dart';

import '../../repository/model/knowledge_list_model.dart';

class KnowledgeViewModel extends GetxController {
  var list = <KnowledgeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getKnowledgeList();
  }

  Future _getKnowledgeList() async {
    var resp = await WanApi.instance.knowledgeList();
    if (resp != null && resp.isNotEmpty == true) {
      list.clear();
      list.addAll(resp);
    }
  }

  List<KnowledgeDetailParam> generalParams(List<Children?>? children) {
    List<KnowledgeDetailParam> params = [];

    children?.forEach((element) {
      params.add(KnowledgeDetailParam(
        element?.name,
        "${element?.id}",
      ));
    });

    return params;
  }
}
