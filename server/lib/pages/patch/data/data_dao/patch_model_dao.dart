import 'package:HotUpdateService/pages/patch/data/data_model/patch_model.dart';
import 'package:simple_mysql_orm/simple_mysql_orm.dart';

/*
* 补丁表操作sql相关
* Created by Wang Meng on 2022/5/11.
* Copyright © 2022 58. All rights reserved.
* */
class PatchDao extends Dao<Patch> {
  PatchDao() : super(tablename);

  PatchDao.withDb(Db db) : super.withDb(db, tablename);

  /**
   * 补丁表名字
   */
  static String get tablename => 'patch_info';

  @override
  Patch fromRow(Row row) => Patch.fromRow(row);

  /**
   * 通过项目唯一标识查询项目下的所有补丁信息
   */
  Future<List<Patch>> search(String app_id) async =>
      query('select * from $tablename where app_id like ?', ['$app_id']);

  /**
   *通过bundle_id查询单个补丁信息
   */
  Future<List<Patch>> searchBundleId(String bundle_id) async =>
      query('select * from $tablename where bundle_id like ?', ['$bundle_id']);

  /**
   * 通过bundle_id查询单个补丁信息
   */
  Future<Patch?> getPatchByBundleId(int bundleId) async {
    final rows =
        await query('select * from $tablename where bundle_id = ?', [bundleId]);
    // ignore: always_put_control_body_on_new_line
    if (rows.isEmpty) return null;
    if (rows.length != 1) {
      throw TooManyResultsException(
          'Multiple $tablename with buildId=$bundleId found.');
    }
    return rows.first;
  }

  /**
   * 更新补丁表信息
   */
  Future<void> updateByPatch(Entity<Patch> entity) async {
    final fields = entity.fields;
    final values = convertToDb(entity.values);
    final sql = 'update patch_info '
        'set `${fields.join("`=?, `")}`=? '
        'where bundle_id=?';
    await db.query(sql, [...values, entity.id]);
  }
}
