import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wan_android_flutter/constants.dart';
import 'package:wan_android_flutter/utils/sp_util.dart';

/// 认证拦截器
///
/// 处理Cookie的自动添加和保存
/// 功能：
/// - 请求时自动添加Cookie到请求头
/// - 登录成功时自动保存返回的Cookie
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final cookieList = await SpUtil.getStringList(Constants.spCookieList);
      if (cookieList != null && cookieList.isNotEmpty) {
        options.headers[HttpHeaders.cookieHeader] = cookieList;
      }
    } catch (e) {
      log('获取Cookie失败: $e');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _saveLoginCookie(response);
    super.onResponse(response, handler);
  }

  /// 保存登录返回的Cookie
  void _saveLoginCookie(Response response) {
    if (!response.requestOptions.path.contains('user/login')) {
      return;
    }

    final list = response.headers[HttpHeaders.setCookieHeader];
    if (list == null || list.isEmpty) {
      return;
    }

    final cookieList = list.whereType<String>().toList();
    for (final cookie in cookieList) {
      log('保存Cookie: $cookie');
    }

    SpUtil.saveStringList(Constants.spCookieList, cookieList);
  }
}
