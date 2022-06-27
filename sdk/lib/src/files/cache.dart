import 'package:flutter/material.dart';
import 'base_cache.dart';

const int kCacheMaxCount = 20; //最多缓存20个

class VersionsCache extends FairCache {
  @override
  String get cacheName => "versions";
  VersionsCache._privateConstructor();
  static final VersionsCache _instance = VersionsCache._privateConstructor();
  static VersionsCache get instance {
    return _instance;
  }

  //保存modulename下的版本号和需要更新的文件
  Future saveVersionConfig(String? bundleid,
      {@required String? version}) async {
    if (bundleid == null || bundleid.isEmpty || version == null) return;
    Map value = {
      "version": version,
      "time": '${DateTime.now().millisecondsSinceEpoch}'
    };
    await setValue(bundleid, value);
  }

  //获取moduleName对应的cache版本号
  Future<String?> getCacheVersion(String bundleid) async {
    var value = await getValueForKey(bundleid);
    if (value != null && value is Map) {
      return value["version"];
    }
    return null;
  }

  Future removeOldCache() async {
    Map? map = await getAllDatas();
    if (map == null) return;
    if (map.keys.length < kCacheMaxCount) {
      return;
    }
    String minKey = "";
    double minTime = 0;
    for (var key in map.keys) {
      if (!(map[key] is Map)) {
        continue;
      }
      Map value = map[key] as Map;
      double time = double.parse(value['time']);
      if (minTime == 0 || time < minTime) {
        minKey = key;
        minTime = time;
      }
    }
    map.remove(minKey);
  }
}
