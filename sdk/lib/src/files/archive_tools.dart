import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'cache.dart';
import 'dart:io';
import 'fair_file.dart';
import '../log/logger.dart';

//加压缩文件，并且更新cache
Future<bool> unZipAndUpdateCache(
    {@required String? zipPath, String? bundleId, String? version}) async {
  List<String>? newFileNames =
      await unZip(zipPath: zipPath, bundleId: bundleId);
  if (newFileNames == null) {
    return false;
  }
  //删除老的文件
  await VersionsCache.instance.removeOldCache();
  await VersionsCache.instance.saveVersionConfig(bundleId, version: version);
  return true;
}

//解压缩
//返回解压缩之后的所有文件名
Future<List<String>?> unZip(
    {@required String? zipPath, @required String? bundleId}) async {
  if (zipPath == null || zipPath.isEmpty) {
    Logger.logi("文件路径不能为空");
    return null;
  }

  if (!File(zipPath).existsSync()) {
    Logger.logi("压缩包文件不存在！");
    return null;
  }

  File zipFile = File(zipPath);
  List<int> bytes = zipFile.readAsBytesSync(); // 从磁盘读取Zip文件。
  Archive archive = ZipDecoder().decodeBytes(bytes); //解压zip文件
  String folderName = "";
  if (bundleId != null) {
    var s = await FairFile.getSaveFilesFolderPath();
    if (s == null) return null;
    folderName = s + "/" + bundleId;
  } else {
    return null;
  }
  List<String> fileNames = [];
  for (ArchiveFile file in archive) {
    if (file.isFile) {
      List<String> names = file.name.split("/");
      String fileName = names.last;
      if (fileName.startsWith(".")) {
        continue;
      }
      String savePath = folderName + "/" + fileName;
      List<int> data = file.content;
      try {
        File(savePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
        fileNames.add(fileName);
      } catch (e) {
        Logger.logi("解压写入文件失败 $e");
        return null;
      }
    } else {
      Directory(folderName)..create(recursive: true);
    }
  }
  try {
    await zipFile.delete(recursive: true);
  } catch (e) {
    Logger.logi(e.toString());
  }
  //移除zip文件

  Logger.logi("解压文件路径 dir = $folderName/");
  return fileNames;
}
