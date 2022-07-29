import 'package:fair_management_web/base/base_view_model.dart';
import 'package:fair_management_web/common/api.dart';
import 'package:fair_management_web/resmgr/subresmgr/sub_res_mgr_page.dart';
import 'package:fair_management_web/resmgr/subrespub/sub_res_pub_page.dart';
import 'package:flutter/src/widgets/framework.dart';

class ResMgrViewModel extends BaseViewModel {
  final int appId;

  ResMgrViewModel({required Api api, required this.appId}) : super(api: api);

  static const pageList = [
    {'name': '资源管理', 'page': SubResMgrPage()},
    {'name': '资源发布', 'page': SubResPubPage()},
  ];

  int index = 0;

  void clickTab(int index) {
    this.index = index;
    notifyListeners();
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

  void clickTabByName(String name) {
    int index = -1;

    for (int i = 0; i < ResMgrViewModel.pageList.length; i++) {
      if (name == ResMgrViewModel.pageList[i]['name']) {
        index = i;
        break;
      }
    }

    if (index != -1) {
      this.index = index;
      notifyListeners();
    }
  }
}
