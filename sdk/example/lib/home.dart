import 'package:example/car_module/car_cate.dart';
import 'package:example/string_const.dart';
import 'package:fair/fair.dart';
import 'package:flutter/material.dart';
import 'package:fair_pushy/fair_pushy.dart';
import 'card.dart';

class HomePage extends StatelessWidget {
  //module间的跳转，使用FairPushyWidget中间件
  void jumpCarModule(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FairPushyWidget(
          bundleid: BundleConst.car,
          // placeholder: (context) => Scaffold(body: Container()),
          onError: (code) => print(code),
          targetWidgetBuilder: (context) => CarCatePage());
    }));
  }

  void jumpJobModule(BuildContext context) {
    //通过getFilePath获取job_job_module_job_home对应的热更新文件地址
    var hotFilePath = FairPushy.getFilePath(
        bundleId: BundleConst.job, filename: 'job_job_module_job_home');

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FairPushyWidget(
        bundleid: BundleConst.job,
        targetPageName: 'dynamic_page',
        params: {"path": hotFilePath},
        //或者直接使用传入widget的方式
        // targetWidgetBuilder: (context) => FairWidget(path: hotFilePath)
      );
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
