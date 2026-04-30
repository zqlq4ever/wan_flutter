import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wan_android_flutter/constants.dart';
import 'package:wan_android_flutter/utils/sp_util.dart';

/// 认证拦截器（IO 平台实现：Android/iOS/Windows/macOS/Linux）
///
/// - 请求时自动添加 Cookie
/// - 登录成功时保存返回的 Cookie
/// - 使用内存缓存，避免每个请求都触发 SharedPreferences IO
class AuthInterceptor extends Interceptor {
  static List<String>? _cookieCache;
  static bool _loaded = false;

  static Future<void> _ensureLoaded() async {
    if (_loaded) return;
    _loaded = true;
    try {
      _cookieCache = await SpUtil.getStringList(Constants.spCookieList);
    } catch (e) {
      log('初始化Cookie失败: $e');
      _cookieCache = null;
    }
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    await _ensureLoaded();
    final cookieList = _cookieCache;
    if (cookieList != null && cookieList.isNotEmpty) {
      options.headers[HttpHeaders.cookieHeader] = cookieList;
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _saveLoginCookie(response);
    super.onResponse(response, handler);
  }

  void _saveLoginCookie(Response response) {
    if (!response.requestOptions.path.contains('user/login')) {
      return;
    }

    final list = response.headers[HttpHeaders.setCookieHeader];
    if (list == null || list.isEmpty) {
      return;
    }

    final cookieList = list.whereType<String>().toList();
    _cookieCache = cookieList;
    for (final cookie in cookieList) {
      log('保存Cookie: $cookie');
    }

    // 登录场景写盘即可（不阻塞响应链路）
    SpUtil.saveStringList(Constants.spCookieList, cookieList);
  }
}
