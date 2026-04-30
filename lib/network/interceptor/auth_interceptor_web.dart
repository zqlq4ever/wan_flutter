import 'package:dio/dio.dart';

/// 认证拦截器（Web 实现）
///
/// Web 环境下浏览器会接管 Cookie（同源或代理场景），Dio 的 header 强行写入 cookie
/// 通常无效且容易引发跨域/安全策略问题，所以这里保持空实现即可。
class AuthInterceptor extends Interceptor {}
