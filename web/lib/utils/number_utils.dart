import 'package:fair_management_web/utils/string_utils.dart';

/// string 转 number
class NumberUtils {
  /// string 转 int
  static int parseInt(String source, {int? defaultNum}) {
    int result = 0;
    if (StringUtils.isEmpty(source)) {
      if (defaultNum != null) {
        defaultNum == 0 ? result : defaultNum;
      } else {
        defaultNum = 0;
      }
      return defaultNum;
    }
    try {
      result = int.parse(source);
    } catch (e) {
      if (defaultNum != null) {
        defaultNum == 0 ? result : defaultNum;
      } else {
        defaultNum = 0;
      }
      return defaultNum;
    }

    return result;
  }

  /// string 转 int
  static double parseDouble(String source, {double? defaultNum}) {
    double result = 0;
    if (StringUtils.isEmpty(source)) {
      if (defaultNum != null) {
        defaultNum == 0 ? result : defaultNum;
      } else {
        defaultNum = 0;
      }
      return defaultNum;
    }
    try {
      result = double.parse(source);
    } catch (e) {
      if (defaultNum != null) {
        defaultNum == 0 ? result : defaultNum;
      } else {
        defaultNum = 0;
      }
      return defaultNum;
    }

    return result;
  }
}
