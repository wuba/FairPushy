import 'package:fair/fair.dart';
import 'package:flutter/material.dart';

@FairPatch(module: "job")
class JobHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("ๆ่้ฆ้กต")),
        body: Container(
          child: Center(child: Text("this is job home page")),
        ));
  }
}
