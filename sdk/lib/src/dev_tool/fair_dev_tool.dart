import 'package:fair_pushy/src/dev_tool/model/dev_tool_model.dart';
import 'package:fair_pushy/src/dev_tool/ui/dev_tool_page.dart';
import 'package:flutter/material.dart';

typedef Widget FairWidgetHandler(String path);

class FairDevTools {
  static FairDevConfig? _config;

  static get config => _config;

  static set config(value) {
    _config = value;
  }

  static FairWidgetHandler? _fairWidgetBuilder;

  static get fairWidgetBuilder => _fairWidgetBuilder;

  static set fairWidgetBuilder(value) {
    _fairWidgetBuilder = value;
  }

  static void openDevPage(BuildContext context) {
    Navigator.of(context, rootNavigator: false)
        .push<void>(MaterialPageRoute(
        settings: RouteSettings(name: "DevToolPage"),
        builder: (context) {
      return DevToolPage();
    }));
  }

}
