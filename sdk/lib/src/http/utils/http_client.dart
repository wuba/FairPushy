import 'dart:convert';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import '../../files/fair_file.dart';
import '../abstract_parser.dart';
import '../base_response.dart';
import '../default_parser.dart';
import '../interceptors/fair_req_logger.dart';
import '../../log/logger.dart';
import '../../project.dart';
import 'permission_utils.dart';

typedef OnProgress = void Function(int count, int toal);

class HttpClient {
  static Future<FResponse<T>?> exec<T>(String url,
      {OnProgress? onProgress,
      Map<String, dynamic>? params,
      BaseParser<T>? parser,
      CancelToken? token}) async {
    var result =
        await PermissionUtils().checkPermission(PermissionEnum.FILE_WRITE);
    if (result == PermissionResult.GRANTED) {
      Dio dio = _initCert();
      var options = _initOptions();
      try {
        var response = await dio.request(url,
            queryParameters: params, options: options, cancelToken: token);
        return _parse<T>(response, parser: parser);
      } on DioError catch (e) {
        var response = FResponse<T>(url: url, code: TimeOut, e: e);
        formatError(e, response);
        return response;
      }
    }
    return FResponse(url: url, e: Exception("请开启读写、网络权限"));
  }

  static Future<FResponse<T>?> _parse<T>(Response response,
      {BaseParser<T>? parser}) async {
    FResponse<T> fResponse = FResponse<T>();
    fResponse.url = response.realUri.toString();
    if (response.statusCode != HttpStatus.ok) {
      fResponse.e = Exception(response.statusMessage);
      return fResponse;
    }
    try {
      parser = parser ?? DefaultParser() as BaseParser<T>;
      var data = response.data;
      var encode = json.encode(data);
      T result = await parser.parse(encode);
      int code = null != result ? Success : Failure;
      fResponse.code = code;
      fResponse.data = result;
      fResponse.e = code == Success ? null : Exception("未返回有效数据");
    } catch (e) {
      Logger.logi(e.toString());
      fResponse.e = Exception(e.toString());
    }
    return fResponse;
  }

  /*
   * 下载文件
   */
  static Future<FResponse?> downloadFile(
      String url, String savePath, String bundleId,
      {Map<String, dynamic>? params,
      OnProgress? onProgress,
      CancelToken? token}) async {
    var result =
        await PermissionUtils().checkPermission(PermissionEnum.FILE_WRITE);
    if (result == PermissionResult.GRANTED) {
      savePath = await _getPath(savePath, bundleId);
      Logger.logi("path: " + savePath);
      return _down(url, savePath, params: params, onProgress: onProgress);
    }
    Logger.logi("请开启读写、网络权限");
    return FResponse(e: Exception("请开启读写、网络权限"));
  }

  static Future<FResponse<String>?> _down(String url, String savePath,
      {Map<String, dynamic>? params, OnProgress? onProgress}) async {
    var dio = _initCert();
    var options = _initOptions();
    try {
      var response = await dio.download(
        url,
        savePath,
        queryParameters: params,
        options: options,
        onReceiveProgress: (count, total) {
          if (onProgress != null) onProgress(count, total);
        },
      );
      //成功还是失败
      int code = response.statusCode == HttpStatus.ok ? Success : Failure;
      return FResponse<String>(
          url: url,
          code: code,
          data: savePath,
          e: code == Success ? null : Exception(response.statusMessage));
    } on DioError catch (e) {
      var response = FResponse<String>(url: url, code: TimeOut, e: e);
      formatError(e, response);
      return response;
    }
  }

  static Future<String> _getPath(String savepath, String bundleId) async {
    if (savepath == "") {
      //文件空或者，file not exist
      Logger.logi("path is null");
      return await FairFile.getDownloadSavePath(moduleName: bundleId);
    }
    return savepath;
  }

  static Dio _initCert() {
    var dio = Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.connectionTimeout = Duration(seconds: 5);
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true; //允许建立链接
      };
      //设置代理
      if (ProjectConfig.instance.URL_PROXY.isNotEmpty) {
        client.findProxy = (url) {
          return ProjectConfig.instance.URL_PROXY;
        };
      }
      return client;
    };
    dio.interceptors.addAll(_initInterceptors());
    return dio;
  }

  static Options _initOptions() {
    var options = Options();
    options.sendTimeout = 5000;
    options.receiveTimeout = 5000;
    Map<String, dynamic> header = {};
    options.headers = header;
    return options;
  }

  static Iterable<Interceptor> _initInterceptors() {
    List<Interceptor> list = List.filled(1, FairReqLogger(), growable: true);
    list.add(FairReqLogger());
    return list;
  }

  static void formatError(DioError e, FResponse response) {
    if (e.type == DioErrorType.connectTimeout) {
      Logger.logi("连接超时");
      response.code = TimeOut;
    } else if (e.type == DioErrorType.sendTimeout) {
      Logger.logi("请求超时");
      response.code = TimeOut;
    } else if (e.type == DioErrorType.receiveTimeout) {
      Logger.logi("响应超时");
      response.code = TimeOut;
    } else if (e.type == DioErrorType.response) {
      Logger.logi("出现异常");
      response.code = Failure;
    } else if (e.type == DioErrorType.cancel) {
      Logger.logi("请求取消");
      response.code = Cancel;
    } else {
      Logger.logi("未知错误");
      response.code = Failure;
    }
  }
}
