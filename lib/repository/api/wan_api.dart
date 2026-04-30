import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wan_android_flutter/config/app_config.dart';
import 'package:wan_android_flutter/network/api_exception.dart';
import 'package:wan_android_flutter/network/dio_client.dart';
import 'package:wan_android_flutter/repository/model/app_check_update_model.dart';
import 'package:wan_android_flutter/repository/model/common_website_model.dart';
import 'package:wan_android_flutter/repository/model/home_banner_bean.dart';
import 'package:wan_android_flutter/repository/model/home_list_model.dart';
import 'package:wan_android_flutter/repository/model/knowledge_detail_list_model.dart';
import 'package:wan_android_flutter/repository/model/knowledge_list_model.dart';
import 'package:wan_android_flutter/repository/model/my_collects_model.dart';
import 'package:wan_android_flutter/repository/model/search_hot_key_model.dart';
import 'package:wan_android_flutter/repository/model/search_list_model.dart';
import 'package:wan_android_flutter/repository/model/user_info_model.dart';
import 'package:wan_android_flutter/repository/url_path_contants.dart';

/// 玩Android API服务
///
/// 封装所有API请求，提供统一的调用入口
/// 使用单例模式管理
class WanApi {
  WanApi._();

  /// 单例实例
  static final WanApi instance = WanApi._();

  /// 获取首页文章列表
  ///
  /// [page] 页码，从0开始
  Future<HomeListModel?> homeList(int page) async {
    try {
      final response = await DioClient.instance.get(
        'article/list/$page/json',
        queryParameters: {'page_size': 10},
      );
      return HomeListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取首页Banner数据
  Future<List<HomeBannerBean>?> getBannerList() async {
    try {
      final response =
          await DioClient.instance.get(UrlPathConstants.pathBanner);
      final model = HomeBannerListModel.fromJson(response.data);
      return model.list;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取搜索热词
  Future<List<SearchHotKeyModel>?> searchHotKeys() async {
    try {
      final response =
          await DioClient.instance.get(UrlPathConstants.pathHotkey);
      final model = SearchHotKeyListModel.fromJson(response.data);
      return model.list;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取常用网站
  Future<List<CommonWebsiteModel>?> commonWebsiteList() async {
    try {
      final response =
          await DioClient.instance.get(UrlPathConstants.pathWebsite);
      final model = CommonWebsiteListModel.fromJson(response.data);
      return model.list;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取知识体系列表
  Future<List<KnowledgeModel>?> knowledgeList() async {
    try {
      final response = await DioClient.instance.get(UrlPathConstants.pathTree);
      final model = KnowledgeListModel.fromJson(response.data);
      return model.list;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取知识体系明细列表
  ///
  /// [id] 知识体系分类ID
  /// [page] 页码，从0开始
  Future<KnowledgeDetailListModel?> knowledgeDetailList(
      String id, int page) async {
    try {
      final response = await DioClient.instance.get(
        'article/list/$page/json',
        queryParameters: {'cid': id},
      );
      return KnowledgeDetailListModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 用户登录
  ///
  /// [username] 用户名
  /// [password] 密码
  Future<UserInfoModel?> login(String? username, String? password) async {
    try {
      final response = await DioClient.instance.post(
        UrlPathConstants.pathLogin,
        queryParameters: {
          'username': username,
          'password': password,
        },
      );
      return UserInfoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 用户注册
  ///
  /// [username] 用户名
  /// [password] 密码
  /// [repassword] 确认密码
  Future<UserInfoModel?> register(
      String? username, String? password, String? repassword) async {
    try {
      final response = await DioClient.instance.post(
        UrlPathConstants.pathRegister,
        queryParameters: {
          'username': username,
          'password': password,
          'repassword': repassword,
        },
      );
      return UserInfoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 用户登出
  Future<bool> logout() async {
    try {
      final response =
          await DioClient.instance.get(UrlPathConstants.pathLogout);
      return response.data == true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 收藏文章
  ///
  /// [id] 文章ID
  Future<bool> collect(String id) async {
    try {
      final response = await DioClient.instance.post('lg/collect/$id/json');
      return response.data == true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 取消收藏文章（首页列表）
  ///
  /// [id] 文章原始ID
  Future<bool> cancelCollect(String id) async {
    try {
      final response =
          await DioClient.instance.post('lg/uncollect_originId/$id/json');
      return response.data == true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 取消收藏文章（我的收藏）
  ///
  /// [id] 收藏记录ID
  /// [originId] 文章原始ID
  Future<bool> cancelCollectFromMyList(String id, String originId) async {
    try {
      final response = await DioClient.instance.post(
        'lg/uncollect/$id/json',
        queryParameters: {'originId': originId},
      );
      return response.data == true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 获取我的收藏列表
  ///
  /// [page] 页码，从0开始
  Future<MyCollectsModel?> getMyCollects(int page) async {
    try {
      final response =
          await DioClient.instance.get('lg/collect/list/$page/json');
      return MyCollectsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 搜索文章
  ///
  /// [keyword] 搜索关键词
  Future<List<SearchListItemModel>> search(String keyword) async {
    try {
      final response = await DioClient.instance.post(
        UrlPathConstants.pathQueryArticle,
        queryParameters: {'k': keyword},
      );
      final model = SearchListModel.fromJson(response.data);
      return model.datas ?? [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 检查APP更新
  Future<AppCheckUpdateModel?> checkUpdate() async {
    try {
      // Web 下直接请求三方域名通常会被 CORS 拦截；这里做降级处理。
      if (kIsWeb) return null;

      if (!AppConfig.hasPgyerKeys) {
        return null;
      }

      final dio = Dio(BaseOptions(
        baseUrl: UrlPathConstants.hostPgyer,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ));

      final response = await dio.post(
        UrlPathConstants.pathCheckUpgrade,
        queryParameters: {
          '_api_key': AppConfig.pgyerApiKey,
          'appKey': AppConfig.pgyerAppKey,
        },
      );
      return AppCheckUpdateModel.fromJson(
          response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// 统一错误处理
  ApiException _handleError(DioException e) {
    final apiException = e.apiException;
    if (apiException != null) {
      return apiException;
    }
    return ApiException(
      code: e.response?.statusCode,
      message: e.message ?? '网络请求失败',
    );
  }
}
