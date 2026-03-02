/// 基础响应模型
///
/// 用于解析API返回的统一数据格式
/// 泛型T表示data字段的实际类型
class BaseResponse<T> {
  /// 响应数据
  T? data;

  /// 错误码，0表示成功
  int? errorCode;

  /// 错误消息
  String? errorMsg;

  BaseResponse({this.data, this.errorCode, this.errorMsg});

  /// 请求是否成功
  bool get isSuccess => errorCode == 0;

  /// 是否为未登录状态
  bool get isNotLogin => errorCode == -1001;

  /// 从JSON创建BaseResponse
  ///
  /// [json] 原始JSON数据
  /// [fromJsonT] 可选的数据转换函数，用于将data字段转换为目标类型
  factory BaseResponse.fromJson(
    Map<String, dynamic> json, [
    T Function(dynamic json)? fromJsonT,
  ]) {
    return BaseResponse<T>(
      data: _parseData(json['data'], fromJsonT),
      errorCode: json['errorCode'],
      errorMsg: json['errorMsg'],
    );
  }

  /// 解析data字段
  static T? _parseData<T>(dynamic data, T Function(dynamic)? fromJsonT) {
    if (data == null) return null;
    if (fromJsonT == null) return data as T?;
    return fromJsonT(data);
  }

  @override
  String toString() {
    return 'BaseResponse{data: $data, errorCode: $errorCode, errorMsg: $errorMsg}';
  }
}
