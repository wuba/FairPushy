import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:dio/dio.dart';
import 'fair_requester_result.dart';
import 'fair_requester_constants.dart';

class FairRequesterDio {
  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String DELETE = 'delete';

  /// 连接服务器超时时间，单位是毫秒.
  static int connectTimeout = 10000;

  /// 接收数据的总时限.
  static int receiveTimeout = 10000;

  late Dio _dio;

  CancelToken cancelToken = CancelToken();

  Dio get dio => _dio;

  ///不同配置的请求
  FairRequesterDio({String baseUrl = FairRequesterConstants.baseUrl, Map<String, dynamic>? headers}) {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      responseType: ResponseType.plain,
      headers: headers,
    );
    _dio = Dio(options);

    //添加拦截器

    _dio.interceptors
      ..add(InterceptorsWrapper(
        /// 请求时的处理
        onRequest: (RequestOptions options,RequestInterceptorHandler handler) {
          print("\n================== 请求数据 ==========================");
          print("url = ${options.uri.toString()}");
          print("data = ${options.data}");
          print("queryParameters = ${options.queryParameters}");
          print("method = ${options.method}");
          print("headers = ${options.headers}");
          handler.next(options);
        },

        /// 响应时的处理
        onResponse: (Response response,ResponseInterceptorHandler handler) {
          print("\n================== 响应数据 ==========================");
          print("code = ${response.statusCode}");
          print("data = ${response.data}");
          print("\n");
          handler.next(response);
        },
        onError: (DioError e,ErrorInterceptorHandler handler) {
          print("\n================== 错误响应数据 ======================");
          print("type = ${e.type}");
          print("error = ${e.error}");
          print("message = ${e.message}");
          print('请求发生错误：${e.response}');
          print("\n");
          handler.next(e);
        },
      ))

      /// 添加 LogInterceptor 拦截器来自动打印请求、响应日志
      ..add(LogInterceptor(
        request: false,
        responseBody: true,
        responseHeader: false,
        requestHeader: false,
      ));
  }

  /// Make http request with options.
  ///
  /// [method] The request method.
  /// [path] The url path.
  /// [data] The request data
  ///
  /// String 返回 json data .
  Future<Response?> request(
    String path, {
    Map<String, dynamic>? data,
    String? method,
    CancelToken? cancelToken,
  }) async {
    Response? response;
    try {
      response = await dio.request(path,
          data: data,
          queryParameters: method == GET ? data : null,
          options: Options(method: method),
          onReceiveProgress: (int count, int total) {},
          onSendProgress: (int count, int total) {},
          cancelToken: cancelToken);
    } on DioError catch (e) {
      formatError(e);
    }
    return response;
  }

  Future<Response?> download(url, savePath,
      {Function(int count, int total)? onReceiveProgress,
      CancelToken? cancelToken}) async {
    print('download请求启动! url：$url');
    Response? response;
    try {
      response = await Dio().download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (int count, int total) {
          print(
              'onReceiveProgress: ${(count / total * 100).toStringAsFixed(0)} %');

          onReceiveProgress!(count, total);
        },
      );
    } on DioError catch (e) {
      print(e.response.toString());
      formatError(e);
    }

    return response;
  }

  /// 上传文件
  ///
  /// [path] The url path.
  /// [data] The request data
  ///
  Future<Response?> uploadFile(String path,
      {String baseUrl = FairRequesterConstants.baseUrl, FormData? data}) async {
    /// 打印请求相关信息：请求地址、请求方式、请求参数
    print("请求地址：【$baseUrl$path】");
    print('请求参数：' + data.toString());
    Response? response;
    try {
      response = await Dio(
        BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: 15000,
            receiveTimeout: 15000,
            headers: _dio.options.headers),
      ).post(
        path,
        data: data,
        onReceiveProgress: (int count, int total) {
          print(
              'onReceiveProgress: ${(count / total * 100).toStringAsFixed(0)} %');
        },
        onSendProgress: (int count, int total) {
          print(
              'onSendProgress: ${(count / total * 100).toStringAsFixed(0)} %');
        },
      );

      /// 响应数据，可能已经被转换了类型, 详情请参考Options中的[ResponseType].
      print('请求成功!response.data：${response.data}');

      /// 响应头
      print('请求成功!response.headers：${response.headers}');

      /// 本次请求信息
      // print('请求成功!response.request：${response.data}');

      /// Http status code.
      print('请求成功!response.statusCode：${response.statusCode}');
    } on DioError catch (e) {
      print(e.response.toString());
      formatError(e);
    }

    return response;
  }

  /// error统一处理
  void formatError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      // It occurs when url is opened timeout.
      print("连接超时 Ծ‸ Ծ");
    } else if (e.type == DioErrorType.sendTimeout) {
      // It occurs when url is sent timeout.
      print("请求超时 Ծ‸ Ծ");
    } else if (e.type == DioErrorType.receiveTimeout) {
      //It occurs when receiving timeout
      print("响应超时 Ծ‸ Ծ");
    } else if (e.type == DioErrorType.response) {
      // When the server response, but with a incorrect status, such as 404, 503...
      print("出现异常 Ծ‸ Ծ");
    } else if (e.type == DioErrorType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      print("请求取消 Ծ‸ Ծ");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      print("未知错误 Ծ‸ Ծ");
    }
  }

  /// 取消请求
  ///
  /// 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。所以参数可选
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  Future<FairRequesterBaseResult?> get(
    String path, {
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async {
    return _requestHttp(path,
        method: GET, params: params, cancelToken: cancelToken);
  }

  Future<FairRequesterBaseResult?> post(
      String path, {
        Map<String, dynamic>? params,
        CancelToken? cancelToken,
      }) async {
    return _requestHttp(path,
        method: POST, params: params, cancelToken: cancelToken);
  }

  Future<FairRequesterBaseResult?> postFormData(
    String path, {
   FormData? params,
    CancelToken? cancelToken,
  }) async => _requestHttp(path,
        method: POST, params: params, cancelToken: cancelToken);

  delete(
    String path, {
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async {
    return _requestHttp(path,
        method: DELETE, params: params, cancelToken: cancelToken);
  }

  Future<FairRequesterBaseResult?> _requestHttp(
    String path, {
    required String method,
    dynamic params,
    CancelToken? cancelToken,
  }) async {
    Response? response;
    try {
      Logger.root.info("fair_dio path is ${path}, request method is ${method}, params is ${params}");
      if (method == GET) {
        Logger.root.info("enter GET");
        response = await dio.get(
          path,
          queryParameters: params,
          cancelToken: cancelToken,
        );
      } else if (method == POST) {
        Logger.root.info("enter POST");
        response = await dio.post(
          path,
          data: params,
          onSendProgress: (int count, int total) {
            print(
                'onSendProgress: ${(count / total * 100).toStringAsFixed(0)} %');
          },
          cancelToken: cancelToken,
        );
      } else if (method == DELETE) {
        Logger.root.info("enter DELETE");
        response = await dio.delete(
          path,
          queryParameters: params,
          cancelToken: cancelToken,
        );
      } else {
        Logger.root.info("enter method else");
      }
    } on DioError catch (error) {
      Logger.root.info("fair_dio requestHttp catch ${error.response.toString()}");
      // 请求错误处理
      print(error.response.toString());
      formatError(error);
      return Future.value(FairRequesterBaseResult(
          message: error.message.toString(),
          code: error.response?.statusCode,
          data: error.message.toString()
          ));
    }
    if (response != null && response.statusCode != null && response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      FairRequesterBaseResult result = FairRequesterBaseResult.fromMap(json.decode(response.data));
      Logger.root.info("fair_dio path is ${path} request method is ${method}, params is ${params} result is ${json.decode(response.data)}");
      return Future.value(result);
    } else {
      Logger.root.info("fair_dio path is ${path} request method is ${method}, params is ${params} response_fail_msg is ${response?.data.toString()}, response_fail_code is ${response?.statusCode.toString()}");
      return Future.value(FairRequesterBaseResult(
          message: response?.data.toString(),
          code: response?.statusCode));
    }
  }
}
