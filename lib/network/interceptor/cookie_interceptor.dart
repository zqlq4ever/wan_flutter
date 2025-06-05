import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wan_android_flutter/constants.dart';
import 'package:wan_android_flutter/utils/sp_utils.dart';

/// 获取登录接口返回的cookie，并添加到请求头中去
class CookieInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    SpUtil.getStringList(Constants.spCookieList).then((cookieList) {
      // 取出缓存的cookie直接赋值给请求头的cookieHeader,注意不是setCookieHeader
      options.headers[HttpHeaders.cookieHeader] = cookieList;
      // options.headers[HttpHeaders.setCookieHeader] = cookieList;
      log("CookieInterceptor onRequest ${cookieList?.length ?? 0} 添加后setCookieHeader=${options.headers[HttpHeaders.setCookieHeader].toString()}");
      handler.next(options);
    });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.path.contains("user/login")) {
      //取出登录接口返回的cookie
      dynamic list = response.headers[HttpHeaders.setCookieHeader];
      //遍历cookie，保存
      List<String> cookieList = [];
      if (list is List) {
        for (String? cookie in list) {
          cookieList.add(cookie ?? "");
          log("获取返回头 cookie：${cookie.toString()}");
        }
      }
      SpUtil.saveStringList(Constants.spCookieList, cookieList);
    }

    // log("获取返回头：${response.headers.toString()}");
    super.onResponse(response, handler);
  }
}
