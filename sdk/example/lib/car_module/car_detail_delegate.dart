import 'package:example/string_const.dart';
import 'package:fair/fair.dart';
import 'package:flutter/material.dart';
import 'package:fair_pushy/fair_pushy.dart';

class CarDetailDelegate extends FairDelegate {
  void push() {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return FairPushyWidget(
        bundleid: BundleConst.job,
        targetPageName: "dynamic_page",
        params: {
          "path": FairPushy.getFilePath(
              bundleId: BundleConst.job, filename: 'job_job_module_job_home')
        },
      );
    }));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Map<String, Function> bindFunction() {
    var fun = super.bindFunction();
    fun['_pop'] = () => Navigator.pop(context);
    fun['_push'] = push;
    return fun;
  }
}
