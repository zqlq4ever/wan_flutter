import 'package:dio/dio.dart';
import 'package:wan_android_flutter/repository/model/home_banner_bean.dart';
import 'package:wan_android_flutter/repository/model/home_list_model.dart';
import 'package:wan_android_flutter/repository/model/knowledge_detail_list_model.dart';
import 'package:wan_android_flutter/repository/model/knowledge_list_model.dart';
import 'package:wan_android_flutter/repository/model/my_collects_model.dart';
import 'package:wan_android_flutter/repository/url_path_contants.dart';

import '../../network/dio_util.dart';
import '../model/app_check_update_model.dart';
import '../model/common_website_model.dart';
import '../model/search_hot_key_model.dart';
import '../model/search_list_model.dart';
import '../model/user_info_model.dart';

class WanApi {
  static WanApi? _instance;

  // 私有构造函数，防止外部实例化
  WanApi._internal();

  // 提供一个静态方法来获取实例
  static WanApi get instance {
    _instance ??= WanApi._internal();
    return _instance!;
  }

  /// 获取首页文章列表
  Future<HomeListModel?> homeList(String pageCount) async {
    Response response = await DioInstance.instance.get(path: "article/list/$pageCount/json");
    return HomeListModel.fromJson(response.data);
  }

  /// 获取置顶文章列表
  Future<HomeTopListModel> topHomeList() async {
    Response response = await DioInstance.instance.get(path: UrlPathConstants.pathTopArticle);
    return HomeTopListModel.fromJson(response.data);
  }

  /// 获取首页 banner 数据
  Future<List<HomeBannerBean>?>? getBannerList() async {
    Response response = await DioInstance.instance.get(path: UrlPathConstants.pathBanner);
    var model = HomeBannerListModel.fromJson(response.data);
    return model.list;
  }

  /// 获取搜索热词
  Future<List<SearchHotKeyModel>?> searchHotKeys() async {
    Response response = await DioInstance.instance.get(path: UrlPathConstants.pathHotkey);
    var model = SearchHotKeyListModel.fromJson(response.data);
    return model.list;
  }

  /// 获取常用网站
  Future<List<CommonWebsiteModel>?> commonWebsiteList() async {
    Response response = await DioInstance.instance.get(path: UrlPathConstants.pathWebsite);
    var model = CommonWebsiteListModel.fromJson(response.data);
    return model.list;
  }

  /// 知识体系列表
  Future<List<KnowledgeModel?>?> knowledgeList() async {
    Response response = await DioInstance.instance.get(path: UrlPathConstants.pathTree);
    var model = KnowledgeListModel.fromJson(response.data);
    return model.list;
  }

  /// 知识体系明细列表数据
  Future<List<KnowledgeDetailItem>?> knowledgeDetailList(String id, String pageCount) async {
    Response response = await DioInstance.instance.get(
      path: "article/list/$pageCount/json",
      param: {"cid": id},
    );
    var model = KnowledgeDetailListModel.fromJson(response.data);
    return model.datas;
  }

  /// 登录
  Future<UserInfoModel?> login(String? name, String? pwd) async {
    Response response = await DioInstance.instance.post(
      path: UrlPathConstants.pathLogin,
      queryParameters: {
        "username": name,
        "password": pwd,
      },
    );
    return UserInfoModel.fromJson(response.data);
  }

  /// 注册
  Future<UserInfoModel?> register(String? name, String? pwd, String? pwdTwice) async {
    Response response = await DioInstance.instance.post(
      path: UrlPathConstants.pathRegister,
      queryParameters: {
        "username": name,
        "password": pwd,
        "repassword": pwdTwice,
      },
    );
    return UserInfoModel.fromJson(response.data);
  }

  /// 登出
  Future<bool> logout() async {
    Response response = await DioInstance.instance.get(path: UrlPathConstants.pathLogout);
    if (response.data != null && response.data == true) {
      return true;
    }
    return false;
  }

  /// 收藏
  Future<bool> collect(String id) async {
    Response response = await DioInstance.instance.post(path: "lg/collect/$id/json");
    if (response.data != null && response.data == true) {
      return true;
    }
    return false;
  }

  /// 取消收藏文章
  Future<bool> cancelCollect(String id) async {
    Response response = await DioInstance.instance.post(path: "lg/uncollect_originId/$id/json");
    if (response.data != null && response.data == true) {
      return true;
    }
    return false;
  }

  /// 获取我的收藏列表
  Future<List<MyCollectItemModel>?> getMyCollects(String pageCount) async {
    Response rsp = await DioInstance.instance.get(path: "lg/collect/list/$pageCount/json");
    MyCollectsModel? model = MyCollectsModel.fromJson(rsp.data);
    if (model.datas != null && model.datas?.isNotEmpty == true) {
      return model.datas;
    }
    return [];
  }

  /// 搜索
  Future<List<SearchListItemModel>?> search({required String keyWord}) async {
    Response rsp = await DioInstance.instance.post(
      path: UrlPathConstants.pathQueryArticle,
      queryParameters: {"k": keyWord},
    );
    SearchListModel? model = SearchListModel.fromJson(rsp.data);
    if (model.datas != null && model.datas?.isNotEmpty == true) {
      return model.datas;
    }
    return [];
  }

  /// 检查 app 新版本
  Future<AppCheckUpdateModel?> checkUpdate() async {
    DioInstance.instance.changeBaseUrl(UrlPathConstants.hostPgyer);
    Response response = await DioInstance.instance.post(
      path: UrlPathConstants.pathCheckUpgrade,
      queryParameters: {
        "_api_key": "57c543d258a34f8565748561de50b6e6",
        "appKey": "2639f784ce9ee850532074b7b0534e62",
      },
    );

    DioInstance.instance.changeBaseUrl(UrlPathConstants.hostWanandroid);

    return AppCheckUpdateModel.fromJson(response.data);
  }
}
