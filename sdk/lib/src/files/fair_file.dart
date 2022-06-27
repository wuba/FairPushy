import 'dart:io';
import 'package:flutter/material.dart';
import 'cache.dart';
import 'package:path_provider/path_provider.dart';
import '../log/logger.dart';

//解压、存取等操作、缓存管理

// ignore: constant_identifier_names
const String _pushy_floder_path = "fairPushy";

class FairFile {
  //获取下载文件的位置
  static Future<String> getDownloadSavePath(
      {@required String? moduleName}) async {
    String? path = await getSaveFilesFolderPath();
    return "$path/$moduleName.zip";
  }

  /// 获取文档目录文件
  static Future<Directory?> getMainFolder() async {
    Directory? dir = await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      dir = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    }
    if (dir != null) {
      String path = dir.path + "/$_pushy_floder_path";
      var newDir = Directory(path);
      try {
        bool exists = await newDir.exists();
        if (!exists) {
          await newDir.create();
        }
      } catch (e) {
        Logger.logi(e.toString());
      }
      return newDir;
    } else {
      return null;
    }
  }

  //保存的文件的路径
  static Future<String?> getSaveFilesFolderPath() async {
    Directory? dir = await getMainFolder();
    if (dir == null) return null;
    var newDir = Directory('${dir.path}/files');
    try {
      bool exists = await newDir.exists();
      if (!exists) {
        await newDir.create();
      }
    } catch (e) {
      Logger.logi(e.toString());
    }
    return newDir.path;
  }

  //删除modulename对应的所有老的文件
  static void removeOldFiles(
      {@required String? moduleName, List<String>? newNames}) async {
    if (moduleName == null || newNames == null) return;
    //得到老的配置
    var value = await VersionsCache.instance.getValueForKey(moduleName);
    if (value != null && value is Map) {
      var files = value["files"];
      for (var filepath in files) {
        if (filepath is String && filepath.isNotEmpty) {
          String? folderPath = await FairFile.getSaveFilesFolderPath();
          String filename = filepath.split("/").last; //拿到文件名
          if (!newNames.contains(filename)) {
            File('$folderPath/$filename').deleteSync(recursive: true);
          }
        }
      }
    }
  }
}
