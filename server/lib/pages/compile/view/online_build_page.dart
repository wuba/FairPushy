import 'package:HotUpdateService/pages/compile/data/data_dao/online_build_model_dao.dart';
import 'package:HotUpdateService/pages/compile/data/data_model/online_build_model.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import 'package:HotUpdateService/utils/requester/fair_requester_result.dart';
import 'package:HotUpdateService/utils/requester/fair_requester.dart';
import 'package:simple_mysql_orm/simple_mysql_orm.dart';
import 'package:process_run/shell.dart';
import 'package:logging/logging.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:typed_data';
import 'dart:io';

/*
* 在线构建接口
* Created by Wang MingYu on 2022/5/11.
* Copyright © 2022 58. All rights reserved.
* */
class OnlineBuildPage extends FairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    /*
    * 在线构建接口入参检查
    * 1. patchGitUrl     补丁项目git地址              必传
    * 2. patchGitBranch  补丁项目git分支              必传
    * 3. patchBuildName  补丁项目构建成功后压缩包名称    必传
    * 4. flutterVersion  构建项目时使用的flutter版本    必传
    * */
    final patchGitUrl = request_params?["patchGitUrl"] ?? "";
    final patchGitBranch = request_params?["patchGitBranch"] ?? "";
    final patchBuildName = request_params?["patchBuildName"] ?? "";
    final flutterVersion = request_params?["flutterVersion"] ?? "";
    if (patchGitUrl == "" ||
        patchGitBranch == "" ||
        patchBuildName == "" ||
        flutterVersion == "") {
      return ParamsError(msg: "开启在线编译失败，入参错误");
    }

    /*
    1. 入参转化为OnlineBuild模型
    2. 使用OnlineBuild模型进行数据库插入操作
    3. 返回在线构建任务id给调用方
     */
    int buildStatus = 2; //构建中
    String patchcdnUrl = "";
    String errorLogUrl = "";
    int buildId = -1;
    await withTransaction<void>(() async {
      final dao = OnlineBuildDao();
      final onlineBuild = OnlineBuild(
          patchGitUrl: patchGitUrl,
          patchGitBranch: patchGitBranch,
          patchBuildName: patchBuildName,
          flutterVersion: flutterVersion,
          buildStatus: buildStatus,
          patchcdnUrl: patchcdnUrl,
          errorLogUrl: errorLogUrl);
      /*
       1.执行数据库插入操作，
       2.获得该条插入数据对应的数据库表记录主键赋值给buildId
       */
      buildId = await dao.persist(onlineBuild);
      onlineBuildProcessHandle(
          buildId, patchGitUrl, patchGitBranch, patchBuildName, flutterVersion);
    }).catchError(((error, stack) {
      return ResponseError(msg: error);
    }));
    ;

    return ResponseSuccess(data: {"buildId": buildId.toString()});
  }

  /*
   * 在线构建流程处理：执行下载git项目、编译项目、上传编译产物至cdn、更新数据库表操作
   * 1.拉取补丁git项目到打包平台特定目录
   * 2.进入到该项目目录，切换git至对应分支
   * 3.执行flutter pub get
   * 4.执行flutter pub run build_runner build
   * 5.上传build产物到cdn，获得cdn上传后的url
   * 6.更新patch_online_build数据库表buildId对应的数据buildStatus patchcdnUrl
   * */
  void onlineBuildProcessHandle(
      int buildId,
      String patchGitUrl,
      String patchGitBranch,
      String patchBuildName,
      String flutterVersion) async {
    var git_dir_path = patchBuildName;

    var shell = Shell();
    shell = shell.cd("/opt/");

    //先删除，避免项目缓存导致未知错误
    await shell.run('''
    rm -rf $git_dir_path
    mkdir -p $git_dir_path
    ''');

    //1~4 拉取项目、切换分支、构建
    shell = shell.cd(git_dir_path);
    await shell.run('''    
    git clone $patchGitUrl ./
    git checkout $patchGitBranch
    
    flutter pub get
    flutter pub run build_runner build
    ''');

    //5 上传build产物 先获取cdn token成功后调起上传
    var fileName = patchBuildName;
    FairRequesterBaseResult tokenResult =
        await FairRequester.instance.getToken(fileName, "dynamic");
    var token = tokenResult.data;
    if (token != null && token is String) {
      final File fairPatchFile =
          File("/opt/${git_dir_path}/build/fair/fair_patch.zip");
      Uint8List fileBytes = await fairPatchFile.readAsBytes();
      uploadPatchFile(buildId, fileName, fileBytes, token);
    } else {
      updateBuildIdTableData(buildId, 1, "", "");
    }
  }

  /*
  * 上传build产物至cdn
  * 获取url更新patch_online_build表中buildId所在记录
  * */
  void uploadPatchFile(
      int buildId, String fileName, Uint8List fileBytes, String token) async {
    Logger.root.info("enter uploadPatchFile func");
    Logger.root.info(
        "buildId is ${buildId}, fileName is ${fileName} fileBytesLength is ${fileBytes.length}");
    var params = Map<String, dynamic>();
    params["op"] = "upload";
    params["insertOnly"] = 0; //必选参数：否 int类型	同名文件覆盖选项，有效值：0 覆盖 1 不覆盖 。默认为1
    params["filecontent"] =
        await dio.MultipartFile.fromBytes(fileBytes, filename: fileName);
    dio.FormData formData = dio.FormData.fromMap(params);

    FairRequesterBaseResult result =
        await FairRequester.instance.uploadFile(fileName, formData, token);
    var resultData = result.data;
    if (resultData != null && resultData is Map) {
      var patchFileUrl = resultData['url'];
      //更新patch_online_build表中buildId所在记录
      if (patchFileUrl != null) {
        updateBuildIdTableData(buildId, 0, patchFileUrl, "");
      } else {
        updateBuildIdTableData(buildId, 1, "", "");
      }
    } else {
      updateBuildIdTableData(buildId, 1, "", "");
    }
  }

  /*
  * 同步操作至数据库，更新表数据
  * */
  void updateBuildIdTableData(int buildId, int buildStatus, String patchcdnUrl,
      String errorLogUrl) async {
    final dao = OnlineBuildDao();
    var onlineBuild = await dao.getByBuildId(buildId);
    if (onlineBuild != null) {
      onlineBuild.buildStatus = buildStatus;
      onlineBuild.patchcdnUrl = patchcdnUrl;
      onlineBuild.errorLogUrl = errorLogUrl;
      dao.updateByOnlineBuild(onlineBuild);
    }
  }
}
