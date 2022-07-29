import 'package:simple_mysql_orm/simple_mysql_orm.dart';

abstract class HandyJSON {
  Map<String, dynamic> toJson();
}

/*
* 在线构建模型
* Created by Wang MingYu on 2022/5/11.
* Copyright © 2022 58. All rights reserved.
* */
class OnlineBuild extends Entity<OnlineBuild> implements HandyJSON {
  //buildId patchGitUrl patchBuildName flutterVersion buildStatus patchcdnUrl errorLogUrl

  late int buildId; //在线构建任务id
  late String patchGitUrl; //补丁项目git地址
  late String patchGitBranch; //补丁项目git分支
  late String patchBuildName; //补丁项目构建成功后压缩包名称
  late String flutterVersion; //构建项目时使用的flutter版本
  late int buildStatus; //在线构建任务状态 0：成功 1：失败 2：构建中
  late String patchcdnUrl; //在线构建任务成功后，资源上传到cdn后生成的地址 默认为空传，buildStatus为0时该值有效
  late String errorLogUrl; //在线构建任务失败的日志 默认为空传，buildStatus为1时该值有效

  OnlineBuild._internal({
    required this.buildId,
    required this.patchGitUrl,
    required this.patchGitBranch,
    required this.patchBuildName,
    required this.flutterVersion,
    required this.buildStatus,
    required this.patchcdnUrl,
    required this.errorLogUrl,
  }) : super(buildId);

  /*
  * 在线构建模型初始化方法
  * */
  factory OnlineBuild({
    required String patchGitUrl,
    required String patchGitBranch,
    required String patchBuildName,
    required String flutterVersion,
    required int buildStatus,
    required String patchcdnUrl,
    required String errorLogUrl,
  }) => OnlineBuild._internal(
    buildId: Entity.notSet,
    patchGitUrl: patchGitUrl,
    patchGitBranch: patchGitBranch,
    patchBuildName: patchBuildName,
    flutterVersion: flutterVersion,
    buildStatus: buildStatus,
    patchcdnUrl: patchcdnUrl,
    errorLogUrl: errorLogUrl,
  );

  factory OnlineBuild.fromRow(Row row) {
    final buildId = row.fieldAsInt('buildId');
    final patchGitUrl = row.fieldAsString('patchGitUrl');
    final patchGitBranch = row.fieldAsString('patchGitBranch');
    final patchBuildName = row.fieldAsString('patchBuildName');
    final flutterVersion = row.fieldAsString('flutterVersion');
    final buildStatus = row.fieldAsInt('buildStatus');
    final patchcdnUrl = row.fieldAsString('patchcdnUrl');
    final errorLogUrl = row.fieldAsString('errorLogUrl');

    return OnlineBuild._internal(
      buildId: buildId,
      patchGitUrl: patchGitUrl,
      patchGitBranch: patchGitBranch,
      patchBuildName: patchBuildName,
      flutterVersion: flutterVersion,
      buildStatus: buildStatus,
      patchcdnUrl: patchcdnUrl,
      errorLogUrl: errorLogUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    "buildId": buildId,
    "patchGitUrl": patchGitUrl,
    "patchGitBranch": patchGitBranch,
    "patchBuildName": patchBuildName,
    "flutterVersion": flutterVersion,
    "buildStatus": buildStatus,
    "patchcdnUrl": patchcdnUrl,
    "errorLogUrl": errorLogUrl
  };

  @override
  /*
  * 数据库插入字段
  * */
  FieldList get fields => [
    'patchGitUrl',
    'patchGitBranch',
    'patchBuildName',
    'flutterVersion',
    'buildStatus',
    'patchcdnUrl',
    'errorLogUrl'
  ];

  @override
  /*
  * 数据库插入字段对应的值
  * */
  ValueList get values => [
    patchGitUrl,
    patchGitBranch,
    patchBuildName,
    flutterVersion,
    buildStatus,
    patchcdnUrl,
    errorLogUrl
  ];
}