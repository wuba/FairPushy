import 'dart:convert';
import '../log/logger.dart';
import 'abstract_parser.dart';
import 'entity/config.dart';

class ConfigParser extends BaseParser<Config> {
  @override
  Future<Config> parse(String response) async {
    Logger.logi(json.encode(response).toString());
    Map<String, dynamic> map = json.decode(response);
    Map<String, dynamic> data = map['data'];
    return Config.fromJson(data);
  }
}
