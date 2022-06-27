import 'dart:convert';

import 'package:example/string_const.dart';
import 'package:flutter/material.dart';
import 'package:fair/fair.dart';
import 'package:fair_pushy/fair_pushy.dart';

class CarListPage extends StatelessWidget {
  void buttonClick(BuildContext context) {
    // Navigator.pushNamed(context, 'car_detail');
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return FairWidget(
          name: 'car_detail',
          path: FairPushy.getFilePath(
              bundleId: BundleConst.car,
              filename: 'lib_car_module_car_detail'));
    }));
  }

  final List _list = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  @override
  Widget build(BuildContext context) {
    String path = 'build/fair/lib_car_module_car_list_item.fair.json';
    // String path = FairPushy.getFilePath(
    //     bundleId: BundleConst.car, filename: 'lib_car_module_car_list_item');
    return Scaffold(
      appBar: AppBar(title: Text("列表页")),
      body: ListView(
        children: Sugar.mapEach(_list, (index, e) {
          return GestureDetector(
            onTap: () => buttonClick(context),
            child: FairWidget(
              name: 'car_list_item',
              path: path,
              data: {
                'fairProps': jsonEncode({'index': '$index'})
              },
            ),
          );
        }),
      ),
    );
  }
}
