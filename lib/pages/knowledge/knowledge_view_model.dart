import 'dart:math';
import 'dart:ui';

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
    // HSL颜色空间更适合生成柔和的颜色
    final hue = random.nextDouble() * 360; // 色调（0-360）
    final saturation = 0.3 + random.nextDouble() * 0.4; // 饱和度（0.3-0.7）
    final lightness = 0.7 + random.nextDouble() * 0.2; // 亮度（0.7-0.9）

    // 转换为RGB
    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }
}
