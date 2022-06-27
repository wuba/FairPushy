import 'dart:convert';
import 'dart:io';
import 'package:fair_pushy/src/log/logger.dart';

import 'fair_file.dart';

abstract class FairCache<T> {
  String cacheName = "";
  Map<String, T>? _valueMapping;

  //是否把数据保存到磁盘
  Future setValue(String key, T value, {bool toDist = true}) async {
    await initValueMapping();
    _valueMapping?[key] = value;
    //保存到磁盘
    if (toDist == true) {
      File? file = await _cacheFile();
      if (file == null) return;
      String jsonStr = jsonEncode(_valueMapping);
      file.writeAsString(jsonStr);
    }
  }

  Future<Map<String, T>?> getAllDatas() async {
    await initValueMapping();
    return _valueMapping;
  }

  Future<T?> getValueForKey(String? key) async {
    await initValueMapping();
    //本地取不到，从磁盘取
    if (key == null) return null;
    var bool = _valueMapping?.keys.contains(key);
    if (bool != null && bool) {
      return _valueMapping?[key];
    }

    return null;
  }

  Future initValueMapping() async {
    if (_valueMapping != null) {
      return;
    }
    _valueMapping = {};
    File? file = await _cacheFile();
    if (file != null) {
      String jsonStr = await file.readAsString();
      try {
        var json = jsonDecode(jsonStr);
        if (json != null) {
          for (var key in json.keys) {
            _valueMapping?[key] = json[key];
          }
        }
      } catch (e) {
        Logger.logi(e.toString());
      }
    }
  }

  Future<File?> _cacheFile() async {
    Directory? dir = await FairFile.getMainFolder();
    if (dir == null) return null;
    String path = dir.path + "/$cacheName.txt";
    File file = File(path);
    try {
      await file.create(recursive: true);
    } catch (e) {
      return null;
    }
    return file;
  }
}
