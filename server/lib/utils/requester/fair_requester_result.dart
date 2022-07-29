class FairRequesterBaseResult<T> {
  int? code;
  String? message;
  T? data;

  FairRequesterBaseResult({this.code, this.message, this.data});

  bool isSuccess() {
    if (code != null && code == 0) {
      return true;
    }
    return false;
  }

  static FairRequesterBaseResult fromMap(Map<String, dynamic> map) {
    FairRequesterBaseResult result = FairRequesterBaseResult();
    result.code = map['code'];
    result.message = map['msg'];
    result.data = map['data'];
    return result;
  }
}


