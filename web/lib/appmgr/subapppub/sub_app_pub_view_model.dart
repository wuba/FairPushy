import 'package:fair_management_web/appmgr/app_mgr_view_model.dart';
import 'package:fair_management_web/base/base_view_model.dart';
import 'package:fair_management_web/common/api.dart';
import 'package:fair_management_web/common/base_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SubAppPubViewModel extends BaseViewModel {
  SubAppPubViewModel({required Api api, required this.appMgrViewModel})
      : super(api: api);

  AppMgrViewModel appMgrViewModel;
  bool? createAppResult;
  String? appName;
  String? appDes;

  Future<void> createApp(appName, appInfo, appLogoUrl) async {
    createAppResult = await api.createApp(appName, appInfo, appLogoUrl);
    this.appName = '';
    appDes = '';
    notifyListeners();
    Fluttertoast.showToast(
        msg: "创建成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        webBgColor: '#000000',
        backgroundColor: black,
        textColor: white,
        fontSize: 16.0);
  }

  void cancelCreate() {
    appName = '';
    appDes = '';
    notifyListeners();
    Fluttertoast.showToast(
        msg: "取消成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        webBgColor: '#000000',
        backgroundColor: black,
        textColor: white,
        fontSize: 16.0);

    appMgrViewModel.clickTabByName('项目管理');
  }
}
