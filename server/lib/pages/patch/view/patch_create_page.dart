import 'package:simple_mysql_orm/simple_mysql_orm.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import '../data/data_dao/patch_model_dao.dart';
import '../data/data_model/patch_model.dart';

/*
* 创建补丁接口
* Created by Wang MingYu on 2022/5/11.
* Copyright © 2022 58. All rights reserved.
* */
class CreatePatchPage extends FairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    /*
    * 创建补丁接口入参检查
    * 1. appId          项目唯一标识              必传
    * 2. patchUrl       补丁下载地址              必传
    * 3. remark         备注信息                 必传
    * 4. bundleName     补丁名字                 必传
    * 5. bundleId       补丁唯一标识              非必传，如果为空新建补丁，不为空则进行修改数据
    * 6. bundleVersion  补丁版本                 必传
    * */
    var appId = request_params?["appId"];
    var patchUrl = request_params?["patchUrl"];
    var remark = request_params?["remark"];
    var status = request_params?["status"];
    var bundleName = request_params?["bundleName"];
    var bundleId = request_params?["bundleId"];
    var bundleVersion = request_params?["bundleVersion"];
    if (patchUrl == null || bundleVersion == null) {
      return ParamsError();
    }
    var response;
    try {
      await withTransaction<void>(() async {
        final dao = PatchDao();
        if (bundleId == null) bundleId = "0";
        final patch = Patch(
            app_id: appId,
            bundle_id: int.parse(bundleId),
            patch_url: patchUrl,
            status: status,
            remark: remark,
            bundleName: bundleName,
            bundleVersion: bundleVersion,
            update_time: DateTime.now().toString());
        if (int.parse(bundleId) > 0) {
          await update(patch, dao);
          response = ResponseError(data: null);
        } else {
          response = await dao.persist(patch);
        }
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

  /**
   * 如果bundleId不为空则会根据bundleId进行补丁表数据更新
   */
  Future<void> update(Entity entity, PatchDao dio) async {
    final fields = entity.fields;
    final values = dio.convertToDb(entity.values);

    final sql = 'update patch_info '
        'set `${fields.join("`=?, `")}`=? '
        'where bundle_id=?';

    await dio.db.query(sql, [...values, entity.id]);
  }
}
