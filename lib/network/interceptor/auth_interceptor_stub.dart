import 'package:dio/dio.dart';

/// 认证拦截器（默认降级实现）
///
/// 用于没有 `dart:io`/`dart:html` 的编译目标（例如部分测试环境）。
/// 默认不处理 Cookie。
class AuthInterceptor extends Interceptor {}
