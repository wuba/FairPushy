import 'package:HotUpdateService/pages/project/data/data_dao/project_model_dao.dart';
import 'package:HotUpdateService/pages/project/data/data_model/project_model.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import 'package:simple_mysql_orm/simple_mysql_orm.dart';

/*
* 创建项目接口
* Created by Wang MingYu on 2022/4/11.
* Copyright © 2020 58. All rights reserved.
* */
class CreateProjectPage extends FairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {

    /*
    * 创建项目接口入参校验
    * 1. appName    项目名称          必传
    * 2. appInfo    项目描述          选传
    * 3. appIconUrl 项目图标网络地址    选传
    * */
    final appName = request_params?["appName"] ?? "";
    if (appName == "") {
      return ParamsError(msg: "创建项目失败，项目名称为空");
    }

    /*
    1. 解析其他选传入参
    2. 入参转化为Project模型
    3. 使用Project模型进行数据库插入操作
    4. 返回创建项目结果给调用方
     */
    final appInfo = request_params?["appInfo"] ?? "";
    final appLogoUrl = request_params?["appLogoUrl"] ?? "";
    await withTransaction<void>(() async {
      final dao = ProjectDao();
      final project = Project(
          app_name: appName,
          app_description: appInfo,
          app_pic_url: appLogoUrl,
          create_time: DateTime.now()
      );
      await dao.persist(project);
    }).catchError(((error, stack) {
      return ResponseError(msg: error);
    }));;

    return ResponseSuccess(data: {"desc":"项目创建成功"});
  }
}
