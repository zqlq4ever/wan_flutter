import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';
import 'package:wan_android_flutter/repository/model/knowledge_detail_param.dart';

import '../../repository/model/knowledge_list_model.dart';
import '../../widgets/loading.dart';

class KnowledgeViewModel extends GetxController {
  var list = <KnowledgeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getKnowledgeList();
  }

  Future _getKnowledgeList() async {
    Loading.showLoading();
    var resp = await WanApi.instance.knowledgeList();
    if (resp != null && resp.isNotEmpty == true) {
      list.clear();
      list.addAll(resp);
    }
    Loading.dismissAll();
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

  Color getRandomPastelColor() {
    final random = Random();
    final hsl = HSLColor.fromAHSL(
      1.0, // 透明度 1.0（不透明）
      random.nextDouble() * 360, // 色相 0-360
      random.nextDouble() * 0.4 + 0.3, // 饱和度 0.5-1.0
      random.nextDouble() * 0.3 + 0.5, // 亮度 0.0-0.5
    );
    return hsl.toColor();
  }
}
