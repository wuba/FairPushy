import 'package:fair_management_web/home/home_page.dart';
import 'package:fair_management_web/resmgr/res_mgr_page.dart';
import 'package:fair_management_web/route/route_path.dart';
import 'package:flutter/material.dart';

///路由管理
class RouterManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return PageRouteBuilder(
        settings: settings,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          var uri = Uri.parse(settings.name ?? '');
          switch (uri.host) {
            case RoutePath.monitor:
            case RoutePath.home:
              return const HomePage();
            case RoutePath.appRes:
              return Scaffold(
                  body: ResMgrPage(context,
                      appId: int.parse(uri.queryParameters['appId'] ?? "")));
            default:
              return Scaffold(
                body: Center(
                  child: Text('没有找到对应的页面：${settings.name}'),
                ),
              );
          }
        });
  }
}
