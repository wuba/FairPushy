import 'package:flutter/material.dart';
import 'placeholder.dart';

typedef FPageBuilder = Widget Function(BuildContext context, Map? params);

class PageBuilder {
  PageBuilder._privateConstructor();
  static final PageBuilder _instance = PageBuilder._privateConstructor();
  static PageBuilder get instance {
    return _instance;
  }

  final Map<String, FPageBuilder> _builders = {};
  void registerPageBuilders(Map<String, FPageBuilder>? builders) {
    if (builders != null && builders.isNotEmpty == true) {
      _builders.addAll(builders);
    }
  }

  void registerPageBuilder(String? pageName, FPageBuilder? builder) {
    if (pageName != null && builder != null) {
      _builders[pageName] = builder;
    }
  }

  FPageBuilder? getBuilder(String pageName) {
    return _builders[pageName];
  }

  Map<String, FPageBuilder> builders() {
    return _builders;
  }

  //默认的loadingwidget，可自定义设置
  WidgetBuilder placeholderBuilder = (context) => PlaceHolderWidget();
}
