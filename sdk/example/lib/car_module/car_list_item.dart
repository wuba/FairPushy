import 'package:flutter/material.dart';
import 'package:fair/fair.dart';

@FairPatch()
class CarListItem extends StatelessWidget {
  @FairProps()
  final dynamic fairProps;
  CarListItem({this.fairProps});

  String getIndex() {
    return fairProps["index"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Row(
                children: [
                  Image.network(
                    'https://pic6.58cdn.com.cn/p1/big/n_v2974f596cd01b4fe691154ea1cabd8463_bd5f2a255edf6bfb.jpg',
                    width: 100.0,
                    height: 75.0,
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getIndex(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 17,
                              color: Colors.black),
                        ),
                        Text(
                          '雪佛兰 景程 2011款 改款 1.8 自动 豪华导航版',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 17,
                              color: Colors.black),
                        ),
                        Text(
                          '2011年1月上牌|11万公里',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 14,
                              color: Colors.grey),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            '2.65万',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 17,
                                color: Colors.red),
                          ),
                        ),
                        // Text('$params 参数 $index')
                      ],
                    ),
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
    ;
  }
}
