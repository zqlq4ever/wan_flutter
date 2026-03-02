import 'package:dio/dio.dart';

/// API异常类
///
/// 用于封装API返回的错误信息
/// 包含错误码和错误消息
class ApiException implements Exception {
  /// 错误码
  final int? code;

  /// 错误消息
  final String? message;

  ApiException({this.code, this.message});

  /// 是否为未登录状态
  bool get isNotLogin => code == -1001;

  /// 是否为请求成功
  bool get isSuccess => code == 0;

  @override
  String toString() {
    return 'ApiException{code: $code, message: $message}';
  }
}

/// 扩展DioException，添加ApiException支持
extension DioExceptionExtension on DioException {
  /// 获取ApiException
  ApiException? get apiException {
    if (error is ApiException) {
      return error as ApiException;
    }
    return null;
  }

  /// 是否为未登录异常
  bool get isNotLogin => apiException?.isNotLogin ?? false;
}
