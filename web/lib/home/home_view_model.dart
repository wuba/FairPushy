import 'package:fair_management_web/appmgr/app_mgr_page.dart';
import 'package:fair_management_web/base/base_view_model.dart';
import 'package:fair_management_web/common/api.dart';
import 'package:fair_management_web/operationmgr/operation_mgr_page.dart';
import 'package:fair_management_web/resbuild/res_build_page.dart';
import 'package:fair_management_web/resmgr/res_mgr_page.dart';
import 'package:fair_management_web/ressync/res_sync_page.dart';
import 'package:flutter/cupertino.dart';

class HomeViewModel extends BaseViewModel {

  /// TAB List
  static const appList = [
    {'name': '项目管理', 'page': AppMgrPage()},
    {'name': '资源构建', 'page': ResBuildPage()},
    {'name': '资源同步', 'page': ResSyncPage()},
    {'name': '操作记录', 'page': OperationMgrPage()},
  ];

  //app管理菜单index
  int appMenuIndex = 0;

  HomeViewModel({required Api api}) : super(api: api);

  void appMenuClick(var item) {
    for (var i = 0; i < appList.length; i++) {
      if (item == appList[i]) {
        appMenuIndex = i;
      }
    }
    notifyListeners();
  }

  String getCurrentPageName() {
    String str = '';
    var map = appList[appMenuIndex];
    var result = map['name'];
    if (result is String) {
      str = result;
    }
    return str;
  }

  Widget? getCurrentPage() {
    Widget? page;
    var map = appList[appMenuIndex];
    var result = map['page'];
    if (result is Widget) {
      page = result;
    }
    return page;
  }
}
