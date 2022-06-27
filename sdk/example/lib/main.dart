import 'package:flutter/material.dart';
import 'package:fair_pushy/fair_pushy.dart';
import 'package:fair/fair.dart';
import 'car_module/car_detail_delegate.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FairPushy.init(
      appID: '1001',
      updateUrl: "https://fangfe.58.com/fairapp/module_patch_bundle",
      debug: true);

  runApplication();
}

void runApplication() {
  FairApp.runApplication(
    FairApp(
        child: MyApp(),
        delegate: {"car_detail": (_, data) => CarDetailDelegate()}),
    plugins: {},
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}
