import 'package:fair_management_web/appmgr/subappmgr/sub_app_mgr_page.dart';
import 'package:fair_management_web/appmgr/subapppub/sub_app_pub_page.dart';
import 'package:fair_management_web/base/base_view_model.dart';
import 'package:fair_management_web/common/api.dart';
import 'package:flutter/material.dart';

class AppMgrViewModel extends BaseViewModel {
  AppMgrViewModel({required Api api}) : super(api: api);

  static const pageList = [
    {'name': '项目管理', 'page': SubAppMgrPage()},
    {'name': '项目创建', 'page': SubAppPubPage()},
  ];

  int index = 0;

  void clickTab(int index) {
    this.index = index;
    notifyListeners();
  }

  void clickTabByName(String name) {
    int index = -1;

    for (int i = 0; i < AppMgrViewModel.pageList.length; i++) {
      if (name == AppMgrViewModel.pageList[i]['name']) {
        index = i;
        break;
      }
    }

    if (index != -1) {
      this.index = index;
      notifyListeners();
    }
  }

  Widget? getCurrentPage() {
    Widget? page;
    var map = pageList[index];
    var result = map['page'];
    if (result is Widget) {
      page = result;
    }
    return page;
  }
}
