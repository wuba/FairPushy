import 'package:fair_management_web/appmgr/subappmgr/bean/app_list_data.dart';
import 'package:fair_management_web/network/base_result.dart';
import 'package:fair_management_web/network/fair_dio.dart';
import 'package:fair_management_web/resmgr/subresmgr/bean/res_list_data.dart';
import 'package:flutter/material.dart';
import 'package:fair_management_web/resmgr/subresmgr/bean/res_list_data.dart';

class Api {
  ///获取项目列表
  Future<AppListData?> getAppList() async {
    AppListData? appListData;
    try {
      Map<String, dynamic> params = <String, dynamic>{};
      var result =
          await FairDio.instance.post('/web/getAppList', params: params);
      var data = result?.data;
      if (data is Map<String, dynamic>) {
        appListData = AppListData.fromJson(data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return appListData;
  }

  //获取补丁列表
  Future<ResListData?> getPatchList(dynamic params) async {
    ResListData? resListData;
    try {
      var result =
          await FairDio.instance.get('/web/module_patch', params: params);
      var data = result?.data;
      if (data is Map<String, dynamic>) {
        resListData = ResListData.fromJson(data);
      }
    } catch (e) {
      print(e.toString());
    }
    return resListData;
  }

  ///创建补丁 && 修改本地上传编译
  Future<BaseResult?> createPatch(dynamic params) async {
    var result =
        await FairDio.instance.post('/web/create_patch', params: params);
    return result;
  }

  ///创建并在线编译布丁 && 修改在线编译
  Future<BaseResult?> creatAndBuildPatch(dynamic params) async {
    var result =
    await FairDio.instance.post('/web/create_patch_and_build', params: params);
    return result;
  }

  ///上传补丁文件
  Future<dynamic> uploadPathFile(String fileName, formData) async {
    return await FairDio.instance.uploadFile(
        '/kLRHgFeDkLkL/dynamics/' + fileName,
        data: formData,
        baseUrl: FairDio.uploadBaseUrl);
  }

  ///创建项目
  Future<bool> createApp(
      String appName, String appInfo, String appLogoUrl) async {
    try {
      Map<String, dynamic> params = <String, dynamic>{};
      params['appName'] = appName;
      params['appInfo'] = appInfo;
      params['appLogoUrl'] = appLogoUrl;
      var result =
          await FairDio.instance.post('/web/createApp', params: params);
      return result?.status == '0' ? true : false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  ///获取资源列表
  Future<ResListData?> getResList() async {
    ResListData? resListData;
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'appId':'4',
      };
      var result =
      await FairDio.instance.get('/web/module_patch', params: params);
      var data = result?.data;
      if (data is Map<String, dynamic>) {
        resListData = ResListData.fromJson(data);
      }
    } catch (e) {
      print(e.toString());
    }
    return resListData;
  }
}
