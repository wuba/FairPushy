import 'package:fair_management_web/common/provider_setup.dart';
import 'package:fair_management_web/route/route_path.dart';
import 'package:fair_management_web/route/router_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  _init();
  runApp(const MyApp());
}

void _init() {}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: '58fair',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Uri(scheme: 'fair', host: RoutePath.home).toString(),
        onGenerateRoute: RouterManager.generateRoute,
      ),
    );
  }
}
