import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'base_result.dart';

class FairDio {
  static const String baseUrl = 'http://127.0.0.1:8080/'; //测试地址
  static const String uploadBaseUrl = 'http://127.0.0.1:8080/'; //上传文件

  static const String baseUrlTo58 = ''; //测试环境

  /// 连接服务器超时时间，单位是毫秒.
  static int connectTimeout = 10000;

  /// 接收数据的总时限.
  static int receiveTimeout = 10000;

  late Dio _dio;

  Dio get dio => _dio;

  static FairDio get instance => _getInstance();
  static FairDio? _instance;

  static FairDio _getInstance() {
    _instance ??= FairDio();
    return _instance!;
  }

  FairDio() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      responseType: ResponseType.plain,
      headers: {
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        "Access-Control-Allow-Credentials": true,
        // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "POST, GET"
      },
      contentType: Headers.jsonContentType,
    );
    _dio = Dio(options);

    //添加拦截器
    _dio.interceptors.add(LogInterceptor(
      request: false,
      responseBody: true,
      responseHeader: false,
      requestHeader: false,
    ));

    // _dio.interceptors.add(InterceptorsWrapper(
    //   onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
    //     debugPrint("\n================== 请求数据 ==========================");
    //     debugPrint("url = ${options.uri.toString()}");
    //     debugPrint("data = ${options.data}");
    //     debugPrint("queryParameters = ${options.queryParameters}");
    //     debugPrint("method = ${options.method}");
    //     debugPrint("headers = ${options.headers}");
    //     handler.next(options);
    //   },
    //   onResponse: (Response response, ResponseInterceptorHandler handler) {
    //     debugPrint("\n================== 响应数据 ==========================");
    //     debugPrint("code = ${response.statusCode}");
    //     debugPrint("data = ${response.data}");
    //     debugPrint("\n");
    //     handler.next(response);
    //   },
    //   onError: (DioError e, ErrorInterceptorHandler handler) {
    //     debugPrint("\n================== 错误响应数据 ======================");
    //     debugPrint("type = ${e.type}");
    //     debugPrint("error = ${e.error}");
    //     debugPrint("message = ${e.message}");
    //     debugPrint('请求发生错误：${e.response}');
    //     debugPrint("\n");
    //     handler.next(e);
    //   },
    // ));

    // 设置代理用来调试应用
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //   // config the http client
    //   client.findProxy = (uri) {
    //     //proxy all request to localhost:8888
    //     return "PROXY 10.252.159.126:8888";
    //   };
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) {
    //     return true;
    //   };
    //   // you can also create a new HttpClient to dio
    //   // return new HttpClient();
    // };
  }

  /// Get请求
  ///
  /// [path] 接口路径
  /// [params] 请求参数
  /// [cancelToken] 取消请求
  ///
  /// [BaseResult] 返回数据
  Future<BaseResult?> get(
    String path, {
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async {
    return _requestHttp(path,
        method: "get", params: params, cancelToken: cancelToken);
  }

  /// Post请求
  ///
  /// [path] 接口路径
  /// [params] 请求参数
  /// [cancelToken] 取消请求
  ///
  /// [BaseResult] 返回数据
  Future<BaseResult?> post(
    String path, {
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async {
    return _requestHttp(path,
        method: "post", params: params, cancelToken: cancelToken);
  }

  /// Delete请求
  ///
  /// [path] 接口路径
  /// [params] 请求参数
  /// [cancelToken] 取消请求
  ///
  /// [BaseResult] 返回数据
  Future<BaseResult?> delete(
    String path, {
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async {
    return _requestHttp(path,
        method: "delete", params: params, cancelToken: cancelToken);
  }

  Future<BaseResult?> _requestHttp(
    String path, {
    required String method,
    dynamic params,
    CancelToken? cancelToken,
  }) async {
    Response response;
    try {
      if (method == "get") {
        response = await dio.get(
          path,
          queryParameters: params,
          cancelToken: cancelToken,
        );
      } else if (method == "post") {
        response = await dio.post(
          path,
          data: params,
          cancelToken: cancelToken,
        );
      } else if (method == "delete") {
        response = await dio.delete(
          path,
          queryParameters: params,
          cancelToken: cancelToken,
        );
      } else {
        return Future.value(BaseResult(message: 'error method', status: '-1'));
      }
    } on DioError catch (error) {
      debugPrint(error.response.toString());
      formatError(error);
      return Future.value(BaseResult(
          message: error.message.toString(),
          status: error.response?.statusCode.toString(),
          data: error.message.toString()));
    }
    if (response.statusCode == 200 || response.statusCode == 201) {
      BaseResult result = BaseResult.fromMap(json.decode(response.data));
      return Future.value(result);
    } else {
      return Future.value(BaseResult(
          message: response.data.toString(),
          status: response.statusCode.toString()));
    }
  }

  /// 下载文件
  Future<Response?> download(url, savePath,
      {Function(int count, int total)? onReceiveProgress,
      CancelToken? cancelToken}) async {
    debugPrint('download请求启动! url：$url');
    Response? response;
    try {
      response = await Dio().download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (int count, int total) {
          debugPrint(
              'onReceiveProgress: ${(count / total * 100).toStringAsFixed(0)} %');

          onReceiveProgress!(count, total);
        },
      );
    } on DioError catch (e) {
      debugPrint(e.response.toString());
      formatError(e);
    }

    return response;
  }

  /// 上传文件
  Future<Response?> uploadFile(String path,
      {String baseUrl = baseUrl, @required FormData? data}) async {
    /// 打印请求相关信息：请求地址、请求方式、请求参数
    debugPrint("请求地址：【$baseUrl$path】");
    debugPrint('请求参数：' + data.toString());
    Response? response;
    try {
      response = await Dio(
        BaseOptions(baseUrl: baseUrl),
      ).post(
        path,
        data: data,
        onReceiveProgress: (int count, int total) {
          debugPrint(
              'onReceiveProgress: ${(count / total * 100).toStringAsFixed(0)} %');
        },
        onSendProgress: (int count, int total) {
          debugPrint(
              'onSendProgress: ${(count / total * 100).toStringAsFixed(0)} %');
        },
      );

      /// 响应数据，可能已经被转换了类型, 详情请参考Options中的[ResponseType].
      debugPrint('请求成功!response.data：${response.data}');

      /// 响应头
      debugPrint('请求成功!response.headers：${response.headers}');

      /// 本次请求信息
      // debugPrint('请求成功!response.request：${response.data}');

      /// Http status code.
      debugPrint('请求成功!response.statusCode：${response.statusCode}');
    } on DioError catch (e) {
      debugPrint(e.response.toString());
      formatError(e);
    }

    return response;
  }

  /// error统一处理
  void formatError(DioError e) {
    if (e.type == DioErrorType.connectTimeout) {
      // It occurs when url is opened timeout.
      debugPrint("连接超时");
    } else if (e.type == DioErrorType.sendTimeout) {
      // It occurs when url is sent timeout.
      debugPrint("请求超时");
    } else if (e.type == DioErrorType.receiveTimeout) {
      //It occurs when receiving timeout
      debugPrint("响应超时");
    } else if (e.type == DioErrorType.response) {
      // When the server response, but with a incorrect status, such as 404, 503...
      debugPrint("出现异常");
    } else if (e.type == DioErrorType.cancel) {
      // When the request is cancelled, dio will throw a error with this type.
      debugPrint("请求取消");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      debugPrint("未知错误");
    }
  }

  /// 取消请求
  ///
  /// 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。所以参数可选
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
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
          queryParameters: method == "get" ? data : null,
          options: Options(method: method),
          onReceiveProgress: (int count, int total) {},
          onSendProgress: (int count, int total) {},
          cancelToken: cancelToken);
    } on DioError catch (e) {
      formatError(e);
    }
    return response;
  }
}
