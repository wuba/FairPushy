/*
* 默认返回模型
* Created by Wang Meng on 2022/4/11.
* Copyright © 2020 58. All rights reserved.
*
* status    状态码 0正常 非0错误
* code      与status值相同，兼容有些请求方框架是使用code进行状态码判断的
* data      数据内容
* msg       提示信息
* */
class ResponseBaseModel {
  final int code; //
  final dynamic data;
  final String? msg;

  ResponseBaseModel(
      {required this.code, this.data, this.msg});

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['code'] = code;
    json['data'] = data;
    json['msg'] = msg;
    return json;
  }
}

/**
 * 网络状态码错误码
 * DEFAULT_ERROR 默认错误值
 * PARAMS_ERROR 参数错误
 *
 * DEFAULT_SUCCESS 成功
 */
const PARAMS_ERROR = -2;
const DEFAULT_ERROR = -1;
const DEFAULT_SUCCESS = 0;

ParamsError(
        {String? msg = "参数错误",
        int code = PARAMS_ERROR,
        dynamic data = null}) =>
    ResponseBaseModel(msg: msg, code: code, data: data);

ResponseError(
        {String? msg = "错误",
        int code = DEFAULT_ERROR,
        dynamic data = null}) =>
    ResponseBaseModel(msg: msg, code: code, data: data);

ResponseSuccess(
        {String? msg = "成功",
        int code = DEFAULT_SUCCESS,
        dynamic data}) =>
    ResponseBaseModel(msg: msg,code: code, data: data);
