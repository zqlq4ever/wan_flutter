import 'dart:developer';

import 'package:dio/dio.dart';

/// 网络请求与返回信息打印拦截器
class PrintLogInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log("\nHTTP request-------------->");
    options.headers.forEach((key, value) {
      log("请求头信息：key=$key  value=${value.toString()}");
    });
    log("path:${options.uri}");
    log("method:${options.method}");
    log("data:${options.data}");
    log("参数:${options.queryParameters.toString()}");
    log("<--------------HTTP request\n");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log("\nHTTP response-------------->");
    log("path:${response.realUri}");
    log("headers:${response.headers.toString()}");
    log("statusMessage:${response.statusMessage}");
    log("状态码:${response.statusCode}");
    log("extra:${response.extra.toString()}");
    log("数据:${response.data}");
    log("<--------------HTTP response\n");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("\nonError-------------->");
    log("error:${err.toString()}");
    log("<--------------onError\n");
    super.onError(err, handler);
  }
}
