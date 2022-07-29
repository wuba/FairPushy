import 'package:HotUpdateService/pages/project/data/data_dao/project_model_dao.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import 'package:simple_mysql_orm/simple_mysql_orm.dart';

/*
* 获取项目详情
* Created by Wang Meng on 2022/4/11.
* Copyright © 2020 58. All rights reserved.
* */
class GetProjectPage extends FairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    /*
    * 在线构建接口入参检查
    * 1. app_id     项目唯一标识              必传
    * */
    var app_id = request_params?["app_id"];
    if (app_id == null) {
      return ParamsError(msg: "app_id==null");
    }

    var response = Map<String, dynamic>();

    await withTransaction<void>(() async {
      final dao = ProjectDao();
      var rows = await dao.search(app_id);
      if (rows.length > 0) {
        response = rows[0].toJson();
      }
    }).catchError(((error, stack) {
      return ResponseError(msg: error);
    }));
    return ResponseSuccess(data: response);
  }
}
