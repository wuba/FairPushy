import 'package:HotUpdateService/server/src/get_server.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';

/*
* 参数处理的基类
* Created by Wang Meng on 2022/4/11.
* Copyright © 2020 58. All rights reserved.
* */
abstract class FairServiceWidget extends GetView {
  @override
  Widget build(BuildContext context) {
    try {
      return FutureBuilder(
          future: this.requestHandler(context.request),
          builder: (context, snapshot) {
            if (snapshot?.connectionState == ConnectionState.done) {
              return Success(data: snapshot?.data);
            } else {
              return WidgetEmpty();
            }
          });
    } catch (e) {
      return Error(error: e.toString());
    }
  }

  /**
   * 处理不同请求的参数
   */
  Future<Map<String, dynamic>> requestHandler(ContextRequest req) async {
    if (req.requestMethod == Method.get) {
      return (await this.service(req.uri.queryParameters)).toJson();
    } else if (req.requestMethod == Method.post) {
      return (await this.service(await req.payload())).toJson();
    } else {
      return (await this.service(req.uri.queryParameters)).toJson();
    }
  }

  Future<ResponseBaseModel> service(Map? request_params);
}
