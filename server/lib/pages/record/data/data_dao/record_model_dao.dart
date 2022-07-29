import 'package:simple_mysql_orm/simple_mysql_orm.dart';

import '../data_model/record_model.dart';

/*
* 操作记录表sql操作相关
* Created by Wang MingYu on 2022/5/11.
* Copyright © 2022 58. All rights reserved.
* */
class RecordDao extends Dao<Record> {
  RecordDao() : super(tablename);

  RecordDao.withDb(Db db) : super.withDb(db, tablename);

  /**
   * sql数据表名字
   */
  static String get tablename => 'operation_record';

  @override
  Record fromRow(Row row) => Record.fromRow(row);

  /**
   * 根据app_id查看操作记录
   */
  Future<List<Record>> search(String app_id) async =>
      query('select * from $tablename where app_key like ?', ['$app_id']);
}
