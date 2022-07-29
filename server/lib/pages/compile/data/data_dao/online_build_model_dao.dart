import 'package:simple_mysql_orm/simple_mysql_orm.dart';
import 'package:HotUpdateService/pages/compile/data/data_model/online_build_model.dart';

/*
* 在线构建sql相关
* Created by Wang MingYu on 2022/5/11.
* Copyright © 2022 58. All rights reserved.
* */
class OnlineBuildDao extends Dao<OnlineBuild> {
  OnlineBuildDao() : super(tablename);

  OnlineBuildDao.withDb(Db db) : super.withDb(db, tablename);

  /**
   * sql数据表名字
   */
  static String get tablename => 'online_build';

  /**
   * 通过buildId查询构建数据
   */
  Future<OnlineBuild?> getByBuildId(int buildId) async {
    final rows =
        await query('select * from $tablename where buildId = ?', [buildId]);
    // ignore: always_put_control_body_on_new_line
    if (rows.isEmpty) return null;
    if (rows.length != 1) {
      throw TooManyResultsException(
          'Multiple $tablename with buildId=$buildId found.');
    }
    return rows.first;
  }

  /**
   * 更新在线构建表数据
   */
  Future<void> updateByOnlineBuild(Entity<OnlineBuild> entity) async {
    final fields = entity.fields;
    final values = convertToDb(entity.values);
    final sql = 'update $tablename '
        'set `${fields.join("`=?, `")}`=? '
        'where buildId=?';
    await db.query(sql, [...values, entity.id]);
  }

  @override
  OnlineBuild fromRow(Row row) => OnlineBuild.fromRow(row);
}
