import 'package:simple_mysql_orm/simple_mysql_orm.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import '../data/data_dao/patch_model_dao.dart';

/*
* 获取补丁文件接口
* Created by Wang Meng on 2022/5/11.
* Copyright © 2022 58. All rights reserved.
* */
class GetPatchPage extends FairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    /*
    * 获取补丁文件接口入参检查
    * 1. appId          项目唯一标识              必传
    * */
    var bundleId = request_params?['bundleId'];

    if (bundleId == null || bundleId == "") {
      return ParamsError(msg: "bundleId==null");
    }
    var list;
    try {
      await withTransaction<void>(() async {
        final dao = PatchDao();
        var rows = await dao.searchBundleId(bundleId);
        for (int i = 0; i < rows.length; i++) {
          list = rows[i].toJson();
        }
      });
    } catch (e) {
      return ResponseError(msg: e.toString());
    }
    return ResponseSuccess(data: list);
  }
}
