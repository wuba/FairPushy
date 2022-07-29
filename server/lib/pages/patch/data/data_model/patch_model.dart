import 'package:simple_mysql_orm/simple_mysql_orm.dart';

abstract class HandyJSON {
  Map<String, dynamic> toJson();
}

/*
* 补丁信息模型
* Created by Wang Meng on 2022/5/11.
* Copyright © 2022 58. All rights reserved.
* */
class Patch extends Entity<Patch> implements HandyJSON {
  factory Patch({
    required String app_id, //项目唯一标识id
    required int bundle_id, //补丁唯一标识id
    required String patch_url, //补丁下载的url地址
    required String status, //补丁状态
    required String remark, //补丁状态备注信息
    required String bundleName, //补丁名字
    String? bundleVersion, //补丁版本
    String? update_time, //更新时间
    String? patchGitUrl, //在线构建git地址
    String? patchGitBranch, //在线构建git分支
    String? flutterVersion, //在线构建Flutter分支
  }) =>
      Patch._internal(
          app_id: app_id,
          bundle_id: bundle_id,
          patch_url: patch_url,
          status: status,
          remark: remark,
          bundleName: bundleName,
          bundleVersion: bundleVersion,
          update_time: update_time = DateTime.now().toString(),
          patchGitUrl: patchGitUrl,
          patchGitBranch: patchGitBranch,
          flutterVersion: flutterVersion);

  factory Patch.fromRow(Row row) {
    final app_id = row.fieldAsString('app_id');
    final bundle_id = row.fieldAsInt('bundle_id');
    final patch_url = row.fieldAsString('patch_url');
    final status = row.fieldAsString('status');
    final remark = row.fieldAsString('remark');
    final bundleName = row.fieldAsString('bundle_name');
    final bundleVersion = row.fieldAsString('bundle_version');
    final updateTime = row.fieldAsString('update_time');
    final patchGitUrl = row.fieldAsString('patchGitUrl');
    final patchGitBranch = row.fieldAsString('patchGitBranch');
    final flutterVersion = row.fieldAsString('flutterVersion');

    return Patch._internal(
        app_id: app_id,
        bundle_id: bundle_id,
        patch_url: patch_url,
        status: status,
        remark: remark,
        bundleName: bundleName,
        bundleVersion: bundleVersion,
        update_time: updateTime,
        patchGitUrl: patchGitUrl,
        patchGitBranch: patchGitBranch,
        flutterVersion: flutterVersion);
  }

  /*
  * 在线构建模型初始化方法
  * */
  Patch._internal({
    required this.app_id,
    required this.bundle_id,
    required this.patch_url,
    required this.status,
    required this.remark,
    required this.bundleName,
    this.bundleVersion,
    this.update_time,
    this.patchGitUrl,
    this.patchGitBranch,
    this.flutterVersion,
  }) : super(bundle_id);

  late String app_id;
  late int bundle_id;
  late String patch_url;
  late String status;
  late String remark;
  late String bundleName;
  late String? bundleVersion;
  late DateTime? create_time;
  late String? update_time;
  late String? patchGitUrl;
  late String? patchGitBranch;
  late String? flutterVersion;

  Map<String, dynamic> toJson() => {
        'app_id': app_id,
        'bundle_id': bundle_id,
        'patch_url': patch_url,
        'status': status,
        'remark': remark,
        'bundle_name': bundleName,
        'bundle_version': bundleVersion,
        'update_time': update_time,
        'patchGitUrl': patchGitUrl,
        'patchGitBranch': patchGitBranch,
        'flutterVersion': flutterVersion,
      };

  Map<String, dynamic> toPatchJson() => {
        'patchUrl': patch_url,
        'bundleVersion': bundleVersion,
      };

  /*
  * 数据库插入字段
  * */
  @override
  FieldList get fields => [
        'app_id',
        'bundle_id',
        'patch_url',
        'status',
        'remark',
        'bundle_name',
        'bundle_version',
        'update_time',
        'patchGitUrl',
        'patchGitBranch',
        'flutterVersion',
      ];

  /*
  * 数据库插入字段对应的值
  * */
  @override
  ValueList get values => [
        app_id,
        bundle_id,
        patch_url,
        status,
        remark,
        bundleName,
        bundleVersion,
        update_time,
        patchGitUrl,
        patchGitBranch,
        flutterVersion,
      ];
}
