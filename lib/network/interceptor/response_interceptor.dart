import 'package:dio/dio.dart';
import 'package:wan_android_flutter/repository/url_path_contants.dart';

import '../api_exception.dart';
import '../base_response.dart';

/// 响应拦截器
///
/// 统一处理API响应，提取data字段
/// 功能：
/// - 检查HTTP状态码
/// - 解析业务错误码
/// - 提取data字段作为响应数据
/// - 将业务错误转换为ApiException
class ResponseInterceptor extends Interceptor {
  /// 需要跳过业务处理的路径
  static const _skipPaths = [
    UrlPathConstants.pathCheckUpgrade,
  ];

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final statusCode = response.statusCode ?? 0;
    if (statusCode < 200 || statusCode >= 300) {
      handler.reject(DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.badResponse,
        message: 'HTTP错误: $statusCode',
      ));
      return;
    }

    if (_shouldSkip(response.requestOptions.path)) {
      handler.next(response);
      return;
    }

    final raw = response.data;
    if (raw is! Map<String, dynamic>) {
      handler.reject(DioException(
        requestOptions: response.requestOptions,
        type: DioExceptionType.unknown,
        message: '响应格式错误',
      ));
      return;
    }

    final rsp = BaseResponse.fromJson(raw);

    if (rsp.isSuccess) {
      response.data = rsp.data ?? true;
      handler.next(response);
      return;
    }

    handler.reject(DioException(
      requestOptions: response.requestOptions,
      type: DioExceptionType.unknown,
      message: rsp.errorMsg,
      error: ApiException(
        code: rsp.errorCode,
        message: rsp.errorMsg,
      ),
    ));
  }

  /// 判断是否需要跳过业务处理
  bool _shouldSkip(String path) {
    for (final skipPath in _skipPaths) {
      if (path.contains(skipPath)) {
        return true;
      }
    }
    return false;
  }
}
