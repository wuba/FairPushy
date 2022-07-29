import 'package:simple_mysql_orm/simple_mysql_orm.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import '../data/data_dao/record_model_dao.dart';

/*
* 查询操作记录列表
* Created by Wang Meng on 2022/4/11.
* Copyright © 2020 58. All rights reserved.
* */
class GetRecordPage extends FairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    /*
    * 查询操作记录列表入参检查
    * 1. appId     项目唯一标识              必传
    * */
    var appId = request_params?['appId'];

    if (appId == null) {
      return ParamsError(msg: "appId==null");
    }
    var list = Map<String, dynamic>();
    ;
    var recordList = [];
    await withTransaction<void>(() async {
      final dao = RecordDao();
      var rows = await dao.search(appId);
      for (int i = 0; i < rows.length; i++) {
        recordList.add(rows[i].toJson());
      }
    }).catchError(((error, stack) {
      return ResponseError(msg: error);
    }));
    list["recordList"] = recordList;
    return ResponseSuccess(data: list);
  }
}
