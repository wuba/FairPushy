import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../get_server.dart';
import '../context/context_request.dart';
import '../context/context_response.dart';

enum Method {
  post,
  get,
  put,
  delete,
  ws,
  options,
  dynamic,
}

//typedef RouteCall<Context> = Widget<T> Function<T>(Context context);
typedef Disposer = Function();

String enumValueToString(Object o) => o.toString().split('.').last;

class Route {
  final Bindings? binding;
  final bool needAuth;
  final Map<String, HashSet<GetSocket>> _rooms = <String, HashSet<GetSocket>>{};
  final HashSet<GetSocket> _sockets = HashSet<GetSocket>();
  final Widget? widget;
  final Map path;

  Route(
    this.method,
    this.path,
    this.widget, {
    this.binding,
    // List<String> keys,
    this.needAuth = false,
  }) {
    binding?.dependencies();
  }

  final Method method;

  Method _reqMethod(HttpRequest req) {
    if (req.headers.value('connection')?.toLowerCase() == 'upgrade') {
      return Method.ws;
    }
    if (req.method.toLowerCase() == 'get') {
      return Method.get;
    } else if (req.method.toLowerCase() == 'post') {
      return Method.post;
    } else if (req.method.toLowerCase() == 'put') {
      return Method.put;
    } else if (req.method.toLowerCase() == 'delete') {
      return Method.delete;
    } else if (req.method.toLowerCase() == 'option') {
      return Method.options;
    } else {
      return Method.get;
    }
  }

  void handle(HttpRequest req, {int? status}) {
    var localMethod = method;
    if (method == Method.dynamic) {
      localMethod = _reqMethod(req);
    }
    var request = ContextRequest(req, localMethod);
    request.response = ContextResponse(req.response);

    if (status != null) request.response!.status(status);

    _verifyAuth(
      req: request,
      successCallback: () {
        if (localMethod == Method.ws) {
          WebSocketTransformer.upgrade(req).then((sock) {
            final getSocket = GetSocket.fromRaw(sock, _rooms, _sockets);
            _sendResponse(request, getSocket: getSocket);
          });
        } else {
          _sendResponse(request);
        }
      },
    );
  }

  void _sendResponse(ContextRequest request,
      {GetSocket? getSocket, Widget? failure}) async {
    if (failure != null) {
      // ignore: invalid_use_of_protected_member
      failure.createElement(request, getSocket);
    } else {
      // ignore: invalid_use_of_protected_member
      widget!.createElement(request, getSocket);
    }
  }

  String? _authHandler(ContextRequest req) {
    dynamic token = req.header('Authorization');
    try {
      if (token != null) {
        token = token.first;
        if (token.contains('Bearer')) {
          token = token.replaceAll('Bearer ', '');

          var key = TokenUtil.getJwtKey()!;
          var decClaimSet = verifyJwtHS256Signature(token, key);
          if (decClaimSet.expiry!.isBefore(DateTime.now())) {
            return JwtException.tokenExpired.message;
          }
        } else {
          return JwtException.invalidToken.message;
        }
      } else {
        return JwtException.invalidToken.message;
      }
      return null;
    } on JwtException catch (err) {
      return err.message;
    } catch (err) {
      return JwtException.invalidToken.message;
    }
  }

  void _verifyAuth({
    required ContextRequest req,
    required void Function() successCallback,
  }) {
    Logger.root.info('url：${req.uri},method:${req.method}');
    if (needAuth) {
      _authNewHandler(req, successCallback);
    } else {
      successCallback();
    }
  }

  void _authNewHandler(
      ContextRequest req, void Function() successCallback) async {
    var url = "https://58dun.58.com/pass/app/appCookieIsValid";
    var dio = Dio();
    var dunCookie = req.header("dunCookie");
    var appXxzlsid = req.header("appXxzlsid");
    var ssoCookie = req.header("ssoCookie");
    var username = req.header("username");
    var body = <String, dynamic>{};
    body['dunCookie'] = dunCookie;
    body['appXxzlsid'] = appXxzlsid;
    body['ssoCookie'] = ssoCookie;
    body['username'] = username;
    await dio.post(url, queryParameters: body).then((res) {
      if (res.statusCode == 200) {
        //{\"code\":126,\"mes\":\"sso cookie失效，请重新登录\"}
        Map<String, dynamic> map = jsonDecode(res.data);
        var code = map["code"];
        if (code == 0) {
          successCallback();
        } else {
          _sendResponse(req, failure: Error(error: map["mes"]));
        }
        return res.data;
      } else {
        _sendResponse(req, failure: Error(error: "登录鉴权失败，请重新登录"));
      }
    }).catchError(((error, stack) {
      //处理异常
      _sendResponse(req, failure: Error(error: "登录鉴权失败，请重新登录"));
    }));
  }
}

class RouteParser {
  static Map normalize(
    dynamic path, {
    List<String?>? keys,
  }) {
    String stringPath = path;
    keys ??= [];
    if (path is RegExp) {
      return {'regexp': path, 'keys': keys};
    } else if (path is List) {
      stringPath = '(${path.join('|')})';
    }

    stringPath += '/?';

    stringPath =
        stringPath.replaceAllMapped(RegExp(r'(\.)?:(\w+)(\?)?'), (placeholder) {
      var replace = StringBuffer('(?:');

      if (placeholder[1] != null) {
        replace.write('\.');
      }

      replace.write('([\\w%+-._~!\$&\'()*,;=:@]+))');

      if (placeholder[3] != null) {
        replace.write('?');
      }

      keys!.add(placeholder[2]);

      return replace.toString();
    }).replaceAll('//', '/');

    return {'regexp': RegExp('^$stringPath\$'), 'keys': keys};
  }

  static Map<String?, String?> parseParams(String path, Map routePath) {
    final params = <String?, String?>{};
    Match? paramsMatch = routePath['regexp'].firstMatch(path);
    for (var i = 0; i < routePath['keys'].length; i++) {
      String? param;
      try {
        param = Uri.decodeQueryComponent(paramsMatch![i + 1]!);
      } catch (e) {
        param = paramsMatch![i + 1];
      }

      params[routePath['keys'][i]] = param;
    }
    return params;
  }

  static bool match(String uriPath, String method, Method _method, Map path) {
    return ((enumValueToString(_method) == method.toLowerCase() ||
            _method == Method.dynamic ||
            _method == Method.ws) &&
        path['regexp'].hasMatch(uriPath));
  }
}
