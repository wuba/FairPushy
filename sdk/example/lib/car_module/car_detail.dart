import 'package:fair/fair.dart';
import 'package:flutter/material.dart';

@FairPatch()
class CarDetailPage extends StatelessWidget {
  @FairWell("_push")
  void _push() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("详情页")),
        body: Container(
          child: Center(
              child: Column(
            children: [
              Container(margin: EdgeInsets.all(30), child: Text("二手车详情页")),
              GestureDetector(
                  onTap: _push,
                  child: Text(
                    '点击跳招聘首页',
                    style: TextStyle(color: Colors.blue[700]),
                  ))
            ],
          )),
        ));
  }
}
