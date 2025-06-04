import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wan_android_flutter/repository/url_path_contants.dart';

import '../base_response.dart';

/// 处理返回值拦截器
class RspInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode != 200) {
      handler.reject(DioException(requestOptions: response.requestOptions));
      return;
    }

    //  蒲公英的接口不做处理
    if (response.requestOptions.path.contains(UrlPathConstants.PATH_CHECK_NEW_VERSION)) {
      handler.next(response);
      return;
    }

    //  未登录的错误码为 -1001，其他错误码为 -1，成功为 0
    //  建议对 errorCode 判断当不为 0 的时候，均为错误
    var rsp = BaseResponse.fromJson(response.data);
    if (rsp.errorCode == 0) {
      if (rsp.data == null) {
        handler.next(Response(requestOptions: response.requestOptions, data: true));
      } else {
        handler.next(Response(requestOptions: response.requestOptions, data: rsp.data));
      }
      return;
    }

    if (rsp.errorCode == -1001) {
      handler.reject(DioException(requestOptions: response.requestOptions, message: "未登录"));
      showToast("请先登录");
    } else {
      handler.reject(DioException(requestOptions: response.requestOptions));
    }
  }
}
