import 'package:dio/dio.dart';
import 'package:fair_pushy/fair_pushy.dart';
import 'package:fair_pushy/src/files/cache.dart';
import 'package:fair_pushy/src/http/base_response.dart';
import 'package:fair_pushy/src/http/config_list_parser.dart';
import 'package:fair_pushy/src/http/entity/config.dart';
import 'files/fair_file.dart';
import 'http/utils/http_client.dart';
import 'http/config_parser.dart';
import 'files/archive_tools.dart' as archive;
import 'log/logger.dart';

enum Code {
  getConfigError, //获取config失败
  getConfigTimeOut, //获取config超时
  downloadError, //下载失败
  downloadTimeOut, //下载超时
  unZipError, //解压失败
  success, //成功
}

/*
 * 动态更新处理,读取Config等关键信息，负责从下载好的文件中，解压读出有用信息
 */
class Delegate {
  //处理配置请求，module下载等
  static Future<Code> updateFW({required String bundleId}) async {
    await Delegate.loadFolderPath();
    String url = ProjectConfig.instance.BUNDLE_PATCH_URL;
    var params = <String, dynamic>{};
    params.putIfAbsent("bundleId", () => bundleId);
    if (ProjectConfig.instance.isDebug) {
      params.putIfAbsent("test", () => true);
    }
    CancelToken token = CancelToken();
    FResponse<Config>? response = await HttpClient.exec(url,
        params: params, parser: ConfigParser(), token: token);
    if (Success != response?.code || response?.data == null) {
      return response?.code == TimeOut
          ? Code.getConfigTimeOut
          : Code.getConfigError;
    }
    //如果后端下发的bundleid是空的，用接口传进来的
    if(_stringISNull(response?.data?.bundleId)) {
      response?.data?.bundleId = bundleId;
    }
    return downloadConfig(response!.data!);
  }

  static bool _stringISNull(String? str) {
    return str == null || str.isEmpty || (str == "null");
  }

  static Future<Code> downloadConfig(Config config) async {
    if (config.bundleId == null) {
      return Code.getConfigError;
    }
    String bundleId = config.bundleId ?? "";
    String? version = await VersionsCache.instance.getCacheVersion(bundleId);
    //版本比较
    if (version != null) {
      version = version.replaceAll('.', '');
      String configVersion = config.bundleVersion!.replaceAll('.', '');
      if (int.parse(version) >= int.parse(configVersion)) {
        return Code.success;
      }
    }
    Logger.logi(
        '开始下载文件...bundleid = ${config.bundleId}}, bundleVersion = ${config.bundleVersion}');
    var response = await HttpClient.downloadFile(config.patchUrl!, "", bundleId,
        token: CancelToken());
    if (response?.code == Success && response?.data != null) {
      Logger.logi('下载完成，正在解压......');
      // 执行解压操作
      var updateCache = await archive.unZipAndUpdateCache(
          zipPath: response?.data.toString(),
          bundleId: bundleId,
          version: config.bundleVersion);
      return updateCache ? Code.success : Code.unZipError;
    } else {
      return response?.code == TimeOut
          ? Code.downloadTimeOut
          : Code.downloadError;
    }
  }

  static Future<List<Config>?> getConfigs(String url,
      {required String appId}) async {
    var params = <String, dynamic>{};
    params.putIfAbsent("appId", () => appId);
    CancelToken token = CancelToken();
    FResponse<List<Config>>? response = await HttpClient.exec(url,
        params: params, parser: ConfigListParser(), token: token);
    return response?.data;
  }

  static const String _Debug_suffix = '.fair.json';
  static const String _Release_suffix = '.fair.bin';
  /*
   * 根据bundleId获取widget路径
   */
  static String getFairPath({required String bundleId, String? filename}) {
    if (filename != null &&
        !filename.endsWith(_Debug_suffix) &&
        !filename.endsWith(_Release_suffix)) {
      filename = filename +
          (ProjectConfig.instance.isDebug ? _Debug_suffix : _Release_suffix);
    }
    String folderpath = '$_filesFolderPath/$bundleId/${(filename ?? "")}';
    return folderpath;
  }

  static String _filesFolderPath = "";
  static Future loadFolderPath() async {
    if (_filesFolderPath.isEmpty) {
      _filesFolderPath = await FairFile.getSaveFilesFolderPath() ?? "";
      Logger.logi('热更新文件夹路径：$_filesFolderPath');
    }
    return;
  }
}
