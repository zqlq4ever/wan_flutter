import 'package:flutter/cupertino.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';

import '../../repository/model/search_list_model.dart';

class SearchViewModel with ChangeNotifier {
  List<SearchListItemModel>? dataList = [];

  Future searchList([String? keyWord = ""]) async {
    List<SearchListItemModel>? list = await WanApi.instance.search(keyWord: keyWord ?? "");
    if (list?.isNotEmpty == true) {
      dataList = list ?? [];
      notifyListeners();
    }
  }

  void clearList() {
    dataList?.clear();
    notifyListeners();
  }
}
