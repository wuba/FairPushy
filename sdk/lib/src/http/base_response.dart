const int Success = 0;
const int Failure = 1;
const int TimeOut = 2;
const int Cancel = 3;

class FResponse<T> {
  String? url;
  Exception? e;
  int code = Failure;
  T? data;
  FResponse({this.url, this.e, this.code = Failure, this.data});
}
