import 'package:dio/dio.dart';

class FairReqLogger extends LogInterceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Logger.logi("@@@-onRequest, options: " + options.baseUrl);
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // Logger.logi("@@@-onError, err: " + err.message);
    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Logger.logi("@@@-response, response: " + responseBody.toString());
    handler.next(response);
  }
}
