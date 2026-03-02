import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'interceptor/auth_interceptor.dart';
import 'interceptor/response_interceptor.dart';

/// Dio网络请求客户端
///
/// 单例模式封装Dio，提供统一的网络请求入口
/// 功能：
/// - GET/POST请求
/// - 自动添加拦截器
/// - 统一超时配置
/// - 动态切换BaseUrl
class DioClient {
  DioClient._();

  /// 单例实例
  static final DioClient instance = DioClient._();

  /// Dio实例
  late final Dio _dio;

  /// 是否已初始化
  bool _hasInit = false;

  /// 默认超时时间
  static const _defaultTimeout = Duration(seconds: 30);

  /// 初始化Dio客户端
  ///
  /// [baseUrl] 基础URL
  /// [connectTimeout] 连接超时时间
  /// [receiveTimeout] 接收超时时间
  /// [sendTimeout] 发送超时时间
  /// [enableLog] 是否启用日志（debug模式默认启用）
  void init({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    bool? enableLog,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout ?? _defaultTimeout,
      receiveTimeout: receiveTimeout ?? _defaultTimeout,
      sendTimeout: sendTimeout ?? _defaultTimeout,
      responseType: ResponseType.json,
    ));

    if (kIsWeb) {
      _dio.options.extra['withCredentials'] = true;
    }

    _dio.interceptors.addAll([
      AuthInterceptor(),
      ResponseInterceptor(),
      if (enableLog ?? kDebugMode)
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
    ]);

    _hasInit = true;
  }

  /// 检查是否已初始化
  void _checkInit() {
    if (!_hasInit) {
      throw StateError('DioClient未初始化，请先调用init()方法');
    }
  }

  /// GET请求
  ///
  /// [path] 请求路径
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// [cancelToken] 取消令牌
  /// 返回Response对象
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    _checkInit();
    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: options ?? Options(receiveTimeout: _defaultTimeout),
      cancelToken: cancelToken,
    );
  }

  /// POST请求
  ///
  /// [path] 请求路径
  /// [data] 请求体数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// [cancelToken] 取消令牌
  /// 返回Response对象
  Future<Response> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    _checkInit();
    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options ?? Options(receiveTimeout: _defaultTimeout),
      cancelToken: cancelToken,
    );
  }

  /// PUT请求
  ///
  /// [path] 请求路径
  /// [data] 请求体数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// [cancelToken] 取消令牌
  Future<Response> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    _checkInit();
    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// DELETE请求
  ///
  /// [path] 请求路径
  /// [data] 请求体数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// [cancelToken] 取消令牌
  Future<Response> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    _checkInit();
    return await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// 切换BaseUrl
  ///
  /// [baseUrl] 新的基础URL
  void changeBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// 获取当前BaseUrl
  String get baseUrl => _dio.options.baseUrl;

  /// 获取Dio实例（用于特殊场景）
  Dio get dio => _dio;
}
