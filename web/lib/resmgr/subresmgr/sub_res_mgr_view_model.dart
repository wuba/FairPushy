import 'package:fair_management_web/base/base_view_model.dart';
import 'package:fair_management_web/common/api.dart';
import 'package:fair_management_web/network/base_result.dart';
import 'package:fair_management_web/resmgr/subresmgr/bean/res_list_data.dart';

class SubResMgrViewModel extends BaseViewModel {
  SubResMgrViewModel({required Api api, required this.appId}) : super(api: api);
  final int appId;
  ResListData? resListData;
  bool isLoad = false;

  /**
   * 获取补丁列表
   */
  Future<void> getPatchList(dynamic params) async {
    resListData = await api.getPatchList(params);
    isLoad = false;
    notifyListeners();
  }

  /**
   * 修改补丁在线编译
   */
  Future<BaseResult?> modifyPatchOnLine(
      String bundleId,
      String moduleName,
      String bundleVersion,
      String patchUrl,
      String patchStatus,
      String patchRemark,
      String appId,
      String gitUrl,
      String gitBranch,
      String fluVer) async {
    var params = {
      'bundleId': bundleId,
      'bundleName': moduleName,
      'bundleVersion': bundleVersion,
      'remark': patchRemark,
      'appId': appId,
      'patchGitUrl': gitUrl,
      'patchGitBranch': gitBranch,
      'flutterVersion': fluVer,
    };
    return api.creatAndBuildPatch(params);
  }
}
