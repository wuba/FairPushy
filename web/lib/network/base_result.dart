/// ResponseData
class BaseResult {
  String? status;
  String? message;
  Object? data;

  BaseResult({this.status, this.message, this.data});

  bool isSuccess() {
    if (status != null && status == '0') {
      return true;
    }
    return false;
  }

  static BaseResult fromMap(Map<String, dynamic> map) {
    BaseResult result = BaseResult();
    result.status = '${map['status']}';
    result.message = map['msg'];
    result.data = map['data'];
    return result;
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": message,
        "data": data,
      };
}
