import 'package:fair/fair.dart';
import 'package:flutter/material.dart';

@FairPatch(module: "job")
class JobHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("招聘首页")),
        body: Container(
          child: Center(child: Text("this is job home page")),
        ));
  }
}
