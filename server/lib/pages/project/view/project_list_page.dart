import 'package:HotUpdateService/pages/project/data/data_dao/project_model_dao.dart';
import 'package:HotUpdateService/pages/project/data/data_model/project_model.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import 'package:simple_mysql_orm/simple_mysql_orm.dart';

/*
* 项目列表接口
* Created by Wang MingYu on 2022/4/11.
* Copyright © 2020 58. All rights reserved.
* */
class ProjectListPage extends FairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {

    var response = Map<String, dynamic>();
    var appList = [];

    await withTransaction<void>(() async {
      final dao = ProjectDao();
      final projectList = await dao.getAll();
      for (var project in projectList) {
        appList.add(project.toJson());
      }
    }).catchError(((error, stack) {
      return ResponseError(msg: error);
    }));;

    response["appList"] = appList;
    return ResponseSuccess(data: response, msg: "项目列表查询成功");
  }
}