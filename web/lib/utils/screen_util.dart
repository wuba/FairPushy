import 'dart:io';

import 'package:flutter/material.dart';

class ScreenUtil {
  //缩放因子
  static double scaleNum = 1.0;

  static void init(BuildContext context) {
    if (Platform.isIOS) {
      double screenWidth = MediaQuery.of(context).size.width;
      if (screenWidth > 375.0) {
        double scale = screenWidth / 375.0;
        scale = scale > 1.104 ? 1.104 : scale;
        scaleNum = scale;
      }
    }
  }
}
