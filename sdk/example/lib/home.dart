import 'package:example/car_module/car_cate.dart';
import 'package:example/string_const.dart';
import 'package:fair/fair.dart';
import 'package:flutter/material.dart';
import 'package:fair_pushy/fair_pushy.dart';
import 'card.dart';

class HomePage extends StatelessWidget {
  void jumpCarModule(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FairPushyWidget(
          bundleid: BundleConst.car,
          targetWidgetBuilder: (context) => CarCatePage());
    }));
  }

  void jumpJobModule(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FairPushyWidget(
          bundleid: BundleConst.job,
          targetWidgetBuilder: (context) => FairWidget(
              name: 'job_home',
              path: FairPushy.getFilePath(
                  bundleId: BundleConst.job,
                  filename: 'job_job_module_job_home')));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Row(children: [
        GestureDetector(
          onTap: () => jumpCarModule(context),
          child: FCard(bgColor: Color.fromRGBO(233, 248, 244, 1), title: '二手车'),
        ),
        GestureDetector(
          onTap: () => jumpJobModule(context),
          child: FCard(bgColor: Color.fromRGBO(233, 248, 244, 1), title: '招聘'),
        ),
      ]),
    ));
  }
}
