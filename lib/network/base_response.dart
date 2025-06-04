class BaseResponse<T> {
  T? data;
  int? errorCode;
  String? errorMsg;

  BaseResponse.fromJson(dynamic json) {
    data = json['data'];
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }
}
