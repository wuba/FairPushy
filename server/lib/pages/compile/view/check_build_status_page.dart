import 'package:HotUpdateService/pages/compile/data/data_dao/online_build_model_dao.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import 'package:simple_mysql_orm/simple_mysql_orm.dart';

/*
* 检查构建状态接口
* Created by Wang MingYu on 2022/5/11.
* Copyright © 2022 58. All rights reserved.
* */
class CheckBuildStatusPage extends FairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    /*
    * 检查构建状态接口入参检查
    * buildId    在线构建任务id   必传
    * */
    final buildId = request_params?["buildId"] ?? "";
    if (buildId == "") {
      return ParamsError(msg: "检查构建状态接口失败，入参错误");
    }

    var response = Map<String, dynamic>();

    await withTransaction<void>(() async {
      final dao = OnlineBuildDao();
      var onlineBuild = await dao.getByBuildId(int.parse(buildId));
      if (onlineBuild != null) {
        response["buildStatus"] = onlineBuild.buildStatus;
        response["patchcdnUrl"] = onlineBuild.patchcdnUrl;
        response["errorLogUrl"] = onlineBuild.errorLogUrl;
      } else {
        ResponseError(msg: "buildId不存在");
      }
    }).catchError(((error, stack) {
      return ResponseError(msg: error);
    }));

    return ResponseSuccess(data: response);
  }
}
