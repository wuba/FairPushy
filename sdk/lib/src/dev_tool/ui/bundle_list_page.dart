import 'dart:async';

import 'package:fair_pushy/src/delegate.dart';
import 'package:fair_pushy/src/dev_tool/ui/shake_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fair_pushy/fair_pushy.dart';
import 'package:sensors_plus/sensors_plus.dart';

class BundleListPage extends StatefulWidget {
  String? bundleId;

  BundleListPage({required this.bundleId, Key? key}) : super(key: key);

  @override
  State<BundleListPage> createState() => _BundleListPageState();
}

class _BundleListPageState extends State<BundleListPage> {
  List<String> itemList = [];

  bool _isShow = false;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void initState() {
    super.initState();
    final isLocalEnv = widget.bundleId == null;
    if (isLocalEnv) {
      _registerSensorListener();
    }
    final pageListFuture = isLocalEnv
        ? Delegate.getLocalEnvPageList()
        : Delegate.getBundlePageList(widget.bundleId!);
    pageListFuture.then((pageList) {
      setState(() {
        itemList.addAll(pageList);
      });
    });
  }

  void _registerSensorListener() {
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) async {
      int value = 20;
      if (event.x.abs() > value ||
          event.y.abs() > value ||
          event.z.abs() > value) {
        if (!_isShow) {
          _isShow = true;
          await showDialog<bool>(
            builder: (BuildContext context) {
              return ShakeDialog(
                onDismiss: () {
                  _isShow = false;
                },
              );
            },
            context: context,
            barrierDismissible: false,
          );
        }
      }
    }));
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('在线预览'),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              final item = itemList[index];
              return MaterialButton(
                onPressed: () {
                  Navigator.of(context)
                      .push<void>(MaterialPageRoute(builder: (context) {
                    return FairDevTools.fairWidgetBuilder(FairPushy.getFilePath(
                        bundleId: widget.bundleId ?? "debug", filename: item));
                  }));
                },
                child: Container(
                  height: 50,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                decoration: TextDecoration.none,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 0.5,
                            color: Colors.grey,
                          ))
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class RouteItem {
  final name;
  final routePath;

  RouteItem(this.name, this.routePath);
}
