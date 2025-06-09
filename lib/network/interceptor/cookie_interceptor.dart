import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:wan_android_flutter/constants.dart';
import 'package:wan_android_flutter/utils/sp_util.dart';

/// 获取登录接口返回的 cookie，并添加到请求头中去
class CookieInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    SpUtil.getStringList(Constants.spCookieList).then((cookieList) {
      options.headers[HttpHeaders.cookieHeader] = cookieList;
      handler.next(options);
    });
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.path.contains("user/login")) {
      //  取出登录接口返回的 cookie
      dynamic list = response.headers[HttpHeaders.setCookieHeader];
      //  遍历 cookie，保存
      List<String> cookieList = [];
      if (list is List) {
        for (String? cookie in list) {
          cookieList.add(cookie ?? "");
          log("获取返回头 cookie：${cookie.toString()}");
        }
      }
      SpUtil.saveStringList(Constants.spCookieList, cookieList);
    }

    super.onResponse(response, handler);
  }
}
