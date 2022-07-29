import 'package:simple_mysql_orm/simple_mysql_orm.dart';
import '../data_model/project_model.dart';

/*
* 在线构建sql相关
* Created by Wang MingYu on 2022/5/11.
* Copyright © 2022 58. All rights reserved.
* */
class ProjectDao extends Dao<Project> {
  ProjectDao() : super(tablename);

  ProjectDao.withDb(Db db) : super.withDb(db, tablename);

  /**
   * sql数据表名字
   */
  static String get tablename => 'app_info';

  @override
  Project fromRow(Row row) => Project.fromRow(row);

  /**
   * 通过app_id查询项目信息
   */
  Future<List<Project>> search(String app_id) async =>
      query('select * from $tablename where app_id like ?', ['$app_id']);
}
