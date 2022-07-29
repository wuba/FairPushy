import 'fair_requester_constants.dart';
import 'fair_requester_dio.dart';
import 'package:dio/dio.dart';

class FairRequester {
  FairRequester._privateConstructor();

  static final FairRequester _instance = FairRequester._privateConstructor();

  static FairRequester get instance {
    return _instance;
  }

  ///cdn获取token
  Future<dynamic> getToken(String fileName, String bucketName) async {
    return await FairRequesterDio(baseUrl: FairRequesterConstants.cdnTokenHost)
        .get(FairRequesterConstants.getCdnToken(),
            params: {"filename": fileName, "bucket": bucketName});
  }

  ///cdn上传文件私有写接口
  Future<dynamic> uploadFile(
      String fileName, FormData formData, String token) async {
    return await FairRequesterDio(
            baseUrl: FairRequesterConstants.cdnFileHost,
            headers: {"Authorization": token})
        .postFormData(FairRequesterConstants.cdnUploadFile() + fileName,
            params: formData);
  }

  /*
  * 打包平台在线构建接口
  * patchGitUrl     补丁项目git地址
  * patchGitBranch  补丁项目git分支
  * patchBuildName  补丁项目构建成功后压缩包名称
  * flutterVersion  构建项目时使用的flutter版本
  * */
  Future<dynamic> onlineBuild(String patchGitUrl, String patchGitBranch,
      String patchBuildName, String flutterVersion) async {
    return await FairRequesterDio(
            baseUrl: FairRequesterConstants.packingPlatformHost)
        .post(FairRequesterConstants.onlineBuildInPackingPlatform(), params: {
      "patchGitUrl": patchGitUrl,
      "patchGitBranch": patchGitBranch,
      "patchBuildName": patchBuildName,
      "flutterVersion": flutterVersion,
    });
  }

  /*
  * 打包平台检查构建状态接口
  * buildId  在线构建任务id
  * */
  Future<dynamic> checkBuildStatus(String buildId) async {
    return await FairRequesterDio(
            baseUrl: FairRequesterConstants.packingPlatformHost)
        .post(FairRequesterConstants.checkBuildStatusInPackingPlatform(),
            params: {
          "buildId": buildId,
        });
  }
}
