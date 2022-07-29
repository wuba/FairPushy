import 'package:simple_mysql_orm/simple_mysql_orm.dart';

abstract class HandyJSON {
  Map<String, dynamic> toJson();
}

/*
* 项目模型
* Created by Wang MingYu on 2022/4/11.
* Copyright © 2020 58. All rights reserved.
* */
class Project extends Entity<Project> implements HandyJSON {

  late int app_id; //项目ID 主键Int类型自增
  late String app_name; //项目名称
  late String app_description; //项目描述
  late String app_pic_url; //项目图标网络地址
  late DateTime create_time; //创建时间

  /*
  * 项目模型初始化方法
  * */
  factory Project({
    required String app_name,
    required String app_description,
    required String app_pic_url,
    required DateTime create_time,
  }) => Project._internal(
    app_id: Entity.notSet,
    app_name: app_name,
    app_description: app_description,
    app_pic_url: app_pic_url,
    create_time: create_time,
  );

  factory Project.fromRow(Row row) {
    final app_id = row.fieldAsInt('app_id');
    final app_name = row.fieldAsString('app_name');
    final app_description = row.fieldAsString('app_description');
    final app_pic_url = row.fieldAsString('app_pic_url');
    final create_time = row.fieldAsDateTime('create_time');

    return Project._internal(
      app_id: app_id,
      app_name: app_name,
      app_description: app_description,
      app_pic_url: app_pic_url,
      create_time: create_time,
    );
  }

  Project._internal({
    required this.app_id,
    required this.app_name,
    required this.app_description,
    required this.app_pic_url,
    required this.create_time,
  }) : super(app_id);



  Map<String, dynamic> toJson() => {
    'appId': app_id,
    'appName': app_name,
    'appInfo': app_description,
    'appLogoUrl': app_pic_url,
    'appCreateTime': create_time.toString(), //数据库create_time格式有问题，暂时先返回常串
  };

  @override
  /*
  * 数据库插入字段
  * */
  FieldList get fields => [
    'app_name',
    'app_description',
    'app_pic_url',
    'create_time'
  ];

  @override
  /*
  * 数据库插入字段对应的值
  * */
  ValueList get values => [
    app_name,
    app_description,
    app_pic_url,
    create_time
  ];
}