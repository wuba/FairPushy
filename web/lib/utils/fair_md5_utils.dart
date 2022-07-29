import 'dart:convert';

// import 'package:crypto/crypto.dart';

class FairMd5Utils {
 static String generateMd5(String data) {
    var content = const Utf8Encoder().convert(data);
    // var digest = md5.convert(content);
    // return json.encode(digest.bytes);
    return '';
  }
}
