import 'package:HotUpdateService/pages/record/view/record_create_page.dart';
import 'package:simple_mysql_orm/simple_mysql_orm.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import '../data/data_dao/patch_model_dao.dart';

/*
* 获取补丁列表接口
* Created by Wang Meng on 2022/5/11.
* Copyright © 2022 58. All rights reserved.
* */
class GetPatchListPage extends FairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    /*
    * 获取补丁列表接口入参检查
    * 1. appId          项目唯一标识              必传
    * */
    var appId = request_params?['appId'];

    if (appId == null || appId == "") {
      return ParamsError(msg: "appId==null");
    }
    var list = Map<String, dynamic>();
    var appList = [];
    try {
      await withTransaction<void>(() async {
        final dao = PatchDao();
        var rows = await dao.search(appId);
        for (int i = 0; i < rows.length; i++) {
          appList.add(rows[i].toJson());
        }
      });
    } catch (e) {
      return ResponseError(msg: e.toString());
    }
    list["bundleList"] = appList;
    return ResponseSuccess(data: list);
  }
}
