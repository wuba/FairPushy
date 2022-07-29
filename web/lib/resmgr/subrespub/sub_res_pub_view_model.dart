import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fair_management_web/base/base_view_model.dart';
import 'package:fair_management_web/common/api.dart';
import 'package:fair_management_web/resmgr/res_mgr_view_model.dart';
import 'package:file_picker/file_picker.dart';

import '../../appmgr/subappmgr/bean/app_list_data.dart';
import '../../network/base_result.dart';

class SubResPubViewModel extends BaseViewModel {
  SubResPubViewModel(
      {required Api api, required this.appId})
      : super(api: api);
  final int appId;
  var uploadFileTip = '请选择补丁文件';
  var patchFileUrl;
  AppListData? appListData;
  var appSelectTip = '请选择项目';

  Future<void> getAppList() async {
    appListData = await api.getAppList();
    notifyListeners();
  }

  void uploadPatchFile(String fileName, fileBytes) async {
    var params = Map<String, dynamic>();
    params["op"] = "upload";
    params["filecontent"] =
        MultipartFile.fromBytes(fileBytes, filename: fileName);
    FormData formData = FormData.fromMap(params);
    Response? result = await api.uploadPathFile(fileName, formData);
    var resultData = result?.data;
    if (resultData != null) {
      Map<String, dynamic> map = json.decode(resultData);
      var dataDic = map['data'];
      patchFileUrl = dataDic['url'];
    } else {
      uploadFileTip = '文件上传失败';
    }
    notifyListeners();
  }

  void showFile(String bundleName, String bundleVersion, [void Function(void Function())? setState]) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Uint8List fileBytes = result.files.first.bytes!;
      String fileName = result.files.first.name;
      var name = fileName.split(".");
      uploadFileTip = bundleName + bundleVersion + '.' + name[1];
      uploadPatchFile(uploadFileTip, fileBytes);
      notifyListeners();
      setState!(() {});
    } else {
      // User canceled the picker
    }
  }

  void clearData(){
    uploadFileTip = '请选择补丁文件';
    patchFileUrl = '';
  }

  void setAppSelectTip(String value) {
    appSelectTip = value;
    notifyListeners();
  }

  Future<BaseResult?> createPatch(
    String bundleVersion,
    String appIdentify,
    String patchRemark,
    String moduleName,
    String patchUrl,
    bool timelyUpdate,
  ) async {
    if (patchUrl.isNotEmpty) {
      var params = {
        'patchUrl': patchUrl,
        'status': '1',
        'remark': patchRemark,
        'bundleName': moduleName,
        'appId': appIdentify,
        'bundleVersion': bundleVersion,
      };
      return api.createPatch(params);
    } else {
      var params = {
        'patchUrl': patchFileUrl,
        'status': '1',
        'remark': patchRemark,
        'bundleName': moduleName,
        'appId': appIdentify,
        'bundleVersion': bundleVersion,
      };
      return api.createPatch(params);
    }
  }

  /**
   * 修改补丁本地上传
   */
  Future<BaseResult?> modifyPatchLocalFile(
      String bundleId,
      String moduleName,
      String bundleVersion,
      String patchUrl,
      String patchStatus,
      String patchRemark,
      String appId) async {
    if (patchFileUrl.toString().isNotEmpty && uploadFileTip != '请选择补丁文件') {
      var params = {
        'bundleId': bundleId,
        'bundleName': moduleName,
        'bundleVersion': bundleVersion,
        'patchUrl': patchFileUrl,
        'remark': patchRemark,
        'status': patchStatus,
        'appId': appId,
      };
      return api.createPatch(params);
    } else {
      var params = {
        'bundleId': bundleId,
        'bundleName': moduleName,
        'bundleVersion': bundleVersion,
        'patchUrl': patchUrl,
        'remark': patchRemark,
        'status': patchStatus,
        'appId': appId,
      };
      return api.createPatch(params);
    }
  }

  // appId app唯一标识
  // bundleName  模块名字
  // bundleVersion 模块版本
  // remark 补丁备注
  // patchGitUrl 补丁项目git地址
  // patchGitBranch 补丁项目git分支
  // flutterVersion flutter 版本
  Future<BaseResult?> createAndBuildPatch(
      String bundleVersion,
      String appIdentify,
      String patchRemark,
      String bundleName,
      String patchGitUrl,
      String patchGitBranch,
      String flutterVersion,
      ) async {
      var params = {
        'appId': appIdentify,
        'bundleName': bundleName,
        'bundleVersion': bundleVersion,
        'remark': patchRemark,
        'patchGitUrl': patchGitUrl,
        'patchGitBranch':patchGitBranch,
        'flutterVersion': flutterVersion,
      };
      return api.creatAndBuildPatch(params);
    }
}
