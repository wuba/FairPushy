import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:simple_mysql_orm/simple_mysql_orm.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import 'package:HotUpdateService/pages/patch/data/data_dao/patch_model_dao.dart';
import 'package:HotUpdateService/pages/patch/data/data_model/patch_model.dart';
import 'package:HotUpdateService/utils/requester/fair_requester.dart';
import 'package:HotUpdateService/utils/requester/fair_requester_result.dart';

/*
* 创建或修改模块补丁、并在线构建项目、生成模块补丁的网络地址
* Created by Wang MingYu on 2022/5/18.
* Copyright © 2022 58. All rights reserved.
* 规则：入参没有bundleId字段或为0则说明是创建、其他情况为修改
* 流程：
* */
class CreatePatchAndBuildPage extends FairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    /*
    * 创建或修改模块补丁、并在线构建接口入参检查
    * 1. appId            app唯一标识                   必传
    * 2. bundleName       模块名字                      必传
    * 3. bundleVersion    模块版本                      必传
    * 4. remark           补丁备注                      必传
    * 5. patchGitUrl      补丁项目git地址                必传
    * 6. patchGitBranch   补丁项目git分支                必传
    * 7. patchBuildName   补丁项目构建成功后压缩包名称      必传
    * 8. flutterVersion   构建项目时使用的flutter版本      必传
    * */
    final appId = request_params?["appId"] ?? "";
    final bundleName = request_params?["bundleName"] ?? "";
    final bundleVersion = request_params?["bundleVersion"] ?? "";
    final remark = request_params?["remark"] ?? "";
    final patchGitUrl = request_params?["patchGitUrl"] ?? "";
    final patchGitBranch = request_params?["patchGitBranch"] ?? "";
    final flutterVersion = request_params?["flutterVersion"] ?? "";
    if (appId == "" ||
        bundleName == "" ||
        bundleVersion == "" ||
        remark == "" ||
        patchGitUrl == "" ||
        patchGitBranch == "" ||
        flutterVersion == "") {
      return ParamsError(msg: "创建或修改模块补丁、并在线构建接口入参检查失败，入参错误");
    }

    var bundleId = request_params?["bundleId"] ?? "0";
    final patchBuildName = bundleName + bundleVersion;

    var response;
    try {
      await withTransaction<void>(() async {
        final dao = PatchDao();
        final patch = Patch(
            app_id: appId,
            bundle_id: int.parse(bundleId),
            patch_url: "",
            //初始值为空串
            status: "2",
            //1：可用 2：构建中 3：构建失败
            remark: remark,
            bundleName: bundleName,
            bundleVersion: bundleVersion,
            update_time: DateTime.now().toString(),
            patchGitUrl: patchGitUrl,
            patchGitBranch: patchGitBranch,
            flutterVersion: flutterVersion);
        if (int.parse(bundleId) > 0) {
          //修改
          await dao.updateByPatch(patch);
          //调用在线构建接口、开启任务查询构建状态并更新buildId对应的记录
          onlineBuild(int.parse(bundleId), dao, patchGitUrl, patchGitBranch,
              patchBuildName, flutterVersion);
          response = ResponseSuccess();
        } else {
          //创建
          var dbBundleId = await dao.persist(patch);
          onlineBuild(dbBundleId, dao, patchGitUrl, patchGitBranch,
              patchBuildName, flutterVersion);
          //调用在线构建接口、开启任务查询构建状态并更新buildId对应的记录
          response = ResponseSuccess();
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

  void onlineBuild(
      int bundleId,
      PatchDao dao,
      String patchGitUrl,
      String patchGitBranch,
      String patchBuildName,
      String flutterVersion) async {
    FairRequesterBaseResult onlineBuildResult = await FairRequester.instance
        .onlineBuild(
            patchGitUrl, patchGitBranch, patchBuildName, flutterVersion);
    if (onlineBuildResult.isSuccess() && onlineBuildResult.data is Map) {
      var buildId = onlineBuildResult.data["buildId"];
      int count = 0;
      const period = const Duration(seconds: 30);
      Timer.periodic(period, (timer) async {
        count++;
        if (count >= 14) {
          timer.cancel();
          updatePatch(dao, bundleId, "3", ""); //3构建失败
        } else {
          var isFinishBuild = await checkBuildStatus(buildId, bundleId, dao);
          if (isFinishBuild) {
            timer.cancel();
          }
        }
      });
    } else {
      //打包服务调起失败
      updatePatch(dao, bundleId, "3", ""); //3构建失败
    }
  }

  Future<bool> checkBuildStatus(
      String buildId, int bundleId, PatchDao dao) async {
    FairRequesterBaseResult checkBuildStatusResult =
        await FairRequester.instance.checkBuildStatus(buildId);
    if (checkBuildStatusResult.isSuccess() &&
        checkBuildStatusResult.data is Map) {
      var buildStatus = checkBuildStatusResult.data["buildStatus"];
      var patchcdnUrl = checkBuildStatusResult.data["patchcdnUrl"];
      var errorLogUrl = checkBuildStatusResult.data["errorLogUrl"];
      String? patchStatus = null;
      if (buildStatus == 0) {
        //构建成功
        patchStatus = "1";
      } else if (buildStatus == 1) {
        //构建失败
        patchStatus = "3";
      }
      if (patchStatus != null) {
        updatePatch(dao, bundleId, patchStatus, patchcdnUrl);
        return true;
      } else {
        return false;
      }
    } else {
      updatePatch(dao, bundleId, "3", ""); //3构建失败
      return true;
    }
  }

  Future<bool> updatePatch(
      PatchDao dao, int bundleId, String patchStatus, String patchUrl) async {
    Patch? patch = await dao.getPatchByBundleId(bundleId);
    if (patch != null) {
      patch.status = patchStatus;
      patch.patch_url = patchUrl;
      dao.updateByPatch(patch);
      return false;
    } else {
      return true;
    }
  }
}
