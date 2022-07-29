import 'dart:convert';

class JsonUtils {
  static List<dynamic> decodeAsList(String data) {
    return json.decode(data);
  }

  static Map<String, dynamic> decodeAsMap(String data) {
    return json.decode(data);
  }

  static String toJson(String data) {
    return json.encode(data);
  }

  static String mapToJson(Map map) {
    return json.encode(map);
  }
}
