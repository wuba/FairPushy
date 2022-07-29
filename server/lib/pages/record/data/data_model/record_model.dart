import 'package:simple_mysql_orm/simple_mysql_orm.dart';

abstract class HandyJSON {
  Map<String, dynamic> toJson();
}

/*
* 操作记录模型
* Created by Wang MingYu on 2022/4/11.
* Copyright © 2020 58. All rights reserved.
* */
class Record extends Entity<Record> implements HandyJSON {
  factory Record({
    required String app_key, //app唯一标识
    required String operator, //操作记录人名字
    required String operatio_content, //操作内容
    String? operation_time, //操作时间
  }) =>
      Record._internal(
          app_key: app_key,
          record_id: 0,
          operator: operator,
          operatio_content: operatio_content,
          operation_time: operation_time = DateTime.now().toString());

  factory Record.fromRow(Row row) {
    final app_key = row.fieldAsString('app_key');
    final record_id = row.fieldAsInt('record_id');
    final operator = row.fieldAsString('operator');
    final operatio_content = row.fieldAsString('operatio_content');
    final updateTime = row.fieldAsString('operation_time');

    return Record._internal(
        app_key: app_key,
        record_id: record_id,
        operator: operator,
        operatio_content: operatio_content,
        operation_time: updateTime);
  }


  /*
  * 项目模型初始化方法
  * */
  Record._internal({
    required this.app_key,
    required this.record_id,
    required this.operator,
    required this.operatio_content,
    this.operation_time,
  }) : super(record_id);

  late String app_key;
  late int record_id;
  late String operator;
  late String operatio_content;
  late String? operation_time;

  Map<String, dynamic> toJson() => {
        'app_key': app_key,
        'record_id': record_id,
        'operator': operator,
        'operatio_content': operatio_content,
        'operation_time': operation_time,
      };

  /*
  * 数据库插入字段
  * */
  @override
  FieldList get fields => [
        'app_key',
        'record_id',
        'operator',
        'operatio_content',
        'operation_time',
      ];

  /*
  * 数据库插入字段对应的值
  * */
  @override
  ValueList get values => [
        app_key,
        record_id,
        operator,
        operatio_content,
        operation_time,
      ];
}
