// ignore: constant_identifier_names
const int Success = 0;
// ignore: constant_identifier_names
const int Failure = 1;

class FResponse<T> {
  String? url;
  Exception? e;
  int code = Failure;
  T? data;
  FResponse({this.url, this.e, this.code = Failure, this.data});
}
