import 'dart:convert';
import 'abstract_parser.dart';
import '../log/logger.dart';
import 'entity/config.dart';

class ConfigListParser extends BaseParser<List<Config>> {
  @override
  Future<List<Config>> parse(String response) async {
    Map<String, dynamic> map = json.decode(response);
    List listMap = map['data'];
    Logger.logi(listMap.first.toString());
    List<Config> list = listMap.map((e) => Config.fromJson(e)).toList();
    return list;
  }
}
