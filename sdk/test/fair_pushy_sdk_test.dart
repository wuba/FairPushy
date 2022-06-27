import 'package:fair_pushy/src/delegate.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fair_pushy/fair_pushy.dart';
import 'package:fair_pushy/src/log/logger.dart';

void main() {
  test('adds one to input values', () {
    FairPushy.init(
        appID: "1001",
        updateUrl: "https://fangfe.58.com/fairapp/module_patch_bundle",
        debug: true);
  });

  FairPushy.getConfigs("https://fangfe.58.com/fairapp/module_patch_app")
      .then((value) {
    if (null != value && value.isNotEmpty) {
      Logger.log("first of configs: " + value[0].patchUrl!);
      for (var i = 0; i < value.length; i++) {
        updateBundle(value[i].bundleId ?? "");
      }
    }
  });
}

void updateBundle(String bundleId) {
  FairPushy.updateBundle(bundleId: bundleId).then((value) {
    if (value == Code.success) {
      Logger.log(FairPushy.getFilePath(bundleId: bundleId));
    } else {
      Logger.logi("update failed");
    }
  });
}
