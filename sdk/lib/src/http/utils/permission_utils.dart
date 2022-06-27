// ignore_for_file: constant_identifier_names

import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  Future<PermissionResult> checkPermission(PermissionEnum permission) async {
    var serviceStatus = await Permission.storage.status;
    switch (permission) {
      case PermissionEnum.FILE_READ:
      case PermissionEnum.FILE_WRITE:
        serviceStatus = await Permission.storage.status;
        break;
      case PermissionEnum.INTERNET:
        serviceStatus = await Permission.storage.status;
        break;
    }

    if (ServiceStatus.enabled == serviceStatus) {
      return PermissionResult.GRANTED;
    }
    return PermissionResult.GRANTED;
  }
}

enum PermissionEnum { FILE_READ, FILE_WRITE, INTERNET }

enum PermissionResult { GRANTED, DENIED }
