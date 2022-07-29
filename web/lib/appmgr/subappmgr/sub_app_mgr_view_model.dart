import 'package:fair_management_web/appmgr/subappmgr/bean/app_list_data.dart';
import 'package:fair_management_web/base/base_view_model.dart';
import 'package:fair_management_web/common/api.dart';

class SubAppMgrViewModel extends BaseViewModel {
  SubAppMgrViewModel({required Api api}) : super(api: api);

  AppListData? appListData;

  bool isLoad = false;

  Future<void> getAppList() async {
    appListData = await api.getAppList();
    isLoad = false;
    notifyListeners();
  }
}
