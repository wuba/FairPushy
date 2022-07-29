import 'dart:async';

import 'package:HotUpdateService/server/fair_server_pages.dart';
import 'package:HotUpdateService/server/src/get_server.dart';
import 'package:HotUpdateService/utils/fair_logger.dart';
import 'package:settings_yaml/settings_yaml.dart';
import 'package:simple_mysql_orm/simple_mysql_orm.dart';
import 'config.dart';

void main() async {
  LoggerInit();

  // Create  settings file.
  SettingsYaml.fromString(content: settingsYaml, filePath: 'settings.yaml')
      .save();

  /// Initialise the db pool
  DbPool.fromSettings(pathToSettings: 'settings.yaml');

  runApp(
    GetServer(
      getPages: AppPages.routes,
      port: 8080,
    ),
  );
  print("FairServer ready...");
}
