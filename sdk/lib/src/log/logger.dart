import 'package:flutter/foundation.dart';

class Logger {
  static log(Object msg) {
    debugPrint('【FairPushy】：' + msg.toString());
  }

  static logi(String msg) {
    debugPrint("【FairPushy】：" + msg);
  }
}
