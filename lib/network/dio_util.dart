import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'http_method.dart';
import 'interceptor/cookie_interceptor.dart';
import 'interceptor/print_log_interceptor.dart';
import 'interceptor/response_interceptor.dart';

class DioInstance {
  static DioInstance? _instance;

  DioInstance._internal();

  static DioInstance get instance {
    _instance ??= DioInstance._internal();
    return _instance!;
  }

  final Dio _dio = Dio();
  final _defaultTimeout = const Duration(seconds: 30);
  var _hasInit = false;

  void initDio({
    required String baseUrl,
    String? method = HttpMethod.GET,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ResponseType? responseType = ResponseType.json,
    String? contentType,
  }) async {
    _dio.options = buildBaseOptions(
      method: method,
      baseUrl: baseUrl,
      connectTimeout: connectTimeout ?? _defaultTimeout,
      receiveTimeout: receiveTimeout ?? _defaultTimeout,
      sendTimeout: sendTimeout ?? _defaultTimeout,
      responseType: responseType,
      contentType: contentType,
    );

    if (kIsWeb) {
      _dio.options.extra['withCredentials'] = true;
    }

    _dio.interceptors
      ..add(CookieInterceptor())
      ..add(PrintLogInterceptor())
      ..add(RspInterceptor());

    _hasInit = true;
  }

  /// get请求方式
  Future<Response> get({
    required String path,
    Map<String, dynamic>? param,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (!_hasInit) {
      throw Exception("you should call initDio() first!");
    }
    return await _dio.get(
      path,
      queryParameters: param,
      options: options ??
          Options(
            method: HttpMethod.GET,
            receiveTimeout: _defaultTimeout,
            sendTimeout: _defaultTimeout,
          ),
      cancelToken: cancelToken,
    );
  }

  /// post请求方式
  Future<Response> post(
      {required String path,
      Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken}) async {
    if (!_hasInit) {
      throw Exception("you should call initDio() first!");
    }
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      options: options ??
          Options(
            method: HttpMethod.POST,
            receiveTimeout: _defaultTimeout,
            sendTimeout: _defaultTimeout,
          ),
    );
  }

  BaseOptions buildBaseOptions({
    required String baseUrl,
    String? method = HttpMethod.GET,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    ResponseType? responseType = ResponseType.json,
    String? contentType,
  }) {
    return BaseOptions(
      method: method,
      baseUrl: baseUrl,
      connectTimeout: connectTimeout ?? _defaultTimeout,
      receiveTimeout: receiveTimeout ?? _defaultTimeout,
      sendTimeout: sendTimeout ?? _defaultTimeout,
      responseType: responseType,
      contentType: contentType,
    );
  }

  void changeBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }
}
