import 'package:simple_mysql_orm/simple_mysql_orm.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';

import '../data/data_dao/record_model_dao.dart';
import '../data/data_model/record_model.dart';

/*
* 创建操作记录接口
* Created by Wang Meng on 2022/4/11.
* Copyright © 2020 58. All rights reserved.
*
* appId     项目唯一标识
* operator  操作人
* content   操作内容
* */
Future<ResponseBaseModel> recordOperating(
    String appId, String operator, String content) async {
  var response;
  try {
    await withTransaction<void>(() async {
      final dao = RecordDao();
      final record = Record(
          app_key: appId,
          operator: operator,
          operatio_content: content,
          operation_time: DateTime.now().toString());
      response = await dao.persist(record);
    });
  } catch (e) {
    return ResponseError(msg: e.toString());
  }
  if (response == null) {
    return ResponseError(data: null);
  } else {
    return ResponseSuccess();
  }
}
