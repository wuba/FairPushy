import 'package:example/car_module/car_list.dart';
import 'package:flutter/material.dart';

class CarCatePage extends StatelessWidget {
  void buttonClick(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CarListPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("大类页")),
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(margin: EdgeInsets.all(30), child: Text("二手车大类页")),
            TextButton(
                onPressed: () {
                  buttonClick(context);
                },
                child: Text('点击进列表页'))
          ],
        )));
  }
}
