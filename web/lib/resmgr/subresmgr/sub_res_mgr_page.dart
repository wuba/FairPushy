import 'package:fair_management_web/base/base_view.dart';
import 'package:fair_management_web/common/base_ui.dart';
import 'package:fair_management_web/network/base_result.dart';
import 'package:fair_management_web/resmgr/res_mgr_view_model.dart';
import 'package:fair_management_web/resmgr/subresmgr/bean/res_list_data.dart';
import 'package:fair_management_web/resmgr/subresmgr/sub_res_mgr_view_model.dart';
import 'package:fair_management_web/resmgr/subrespub/sub_res_pub_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SubResMgrPage extends StatefulWidget {
  const SubResMgrPage({Key? key}) : super(key: key);

  @override
  State<SubResMgrPage> createState() => _SubResMgrPageState();
}

class _SubResMgrPageState extends State<SubResMgrPage> {
  DateTime dateTime = DateTime.now();
  late SubResMgrViewModel viewModel;
  SubResPubViewModel? pubViewModel;

  @override
  Widget build(BuildContext context) {
    ResMgrViewModel model = Provider.of<ResMgrViewModel>(context);
    pubViewModel =
        SubResPubViewModel(api: Provider.of(context), appId: model.appId);

    return BaseView<SubResMgrViewModel>(
        model:
            SubResMgrViewModel(api: Provider.of(context), appId: model.appId),
        onModelReady: (model) {
          viewModel = model;
          var params = {'appId': viewModel.appId.toString()};
          model.isLoad = true;
          model.getPatchList(params);
        },
        builder: (context, model, child) {
          if (viewModel.isLoad) {
            return SizedBox(
              height: 500,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(lightBlue),
                ),
              ),
            );
          }

          if (viewModel.resListData?.resList?.isEmpty ?? true) {
            return SizedBox(
              height: 500,
              child: Center(
                  child: Text(
                '暂无数据',
                style: TextStyle(fontSize: 15, color: black),
              )),
            );
          }

          return SizedBox(
            height: 500,
            child: CustomScrollView(
              controller: ScrollController(),
              slivers: [SliverToBoxAdapter(child: buildTable())],
            ),
          );
        });
  }

  Container buildTable() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Table(
        //所有列宽
        columnWidths: const {
          //列宽
          0: FlexColumnWidth(),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FlexColumnWidth(),
        },
        //表格边框样式
        // border: TableBorder.all(
        //   color: Colors.green,
        //   width: 2.0,
        //   style: BorderStyle.solid,
        // ),
        children: [
          TableRow(
              decoration: const BoxDecoration(
                color: Color(0xFFFAFAFA),
              ),
              children: [
                buildItem('BundleId'),
                buildItem('模块名'),
                buildItem('补丁版本'),
                buildItem('补丁状态'),
                buildItem('更新时间'),
                buildItem('备注'),
                buildItem('url'),
                buildItem('操作'),
              ]),
          for (var item in viewModel.resListData?.resList ?? [])
            TableRow(children: [
              buildItem(item.bundle_id.toString()),
              buildItem(item.bundle_name?.toString()),
              buildItem(item.bundle_version?.toString()),
              buildItem(_getStatusStringWithStatus(item.status?.toString())),
              buildItem(item.update_time?.toString()),
              buildItem(item.remark?.toString()),
              buildItem(item.patch_url?.toString()),
              buildItemWithClick("编辑", item),
            ])
        ],
      ),
    );
  }

  String _getStatusStringWithStatus(String? status) {
    if (status == '1') {
      return "编译完成";
    } else if (status == '2') {
      return "在线编译中";
    } else {
      return "编译失败";
    }
  }

  /**
   * 资源列表普通按钮UI
   */
  Container buildItem(String? content) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: SelectableText(
        content ?? '',
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF101010),
        ),
      ),
    );
  }

  /**
   * 资源列表编辑按钮UI
   */
  Container buildItemWithClick(String content, [ResListItemData? item]) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      child: TextButton(
        child: Text(
          '编辑',
          style: TextStyle(
            fontSize: 14,
            color: lightBlue,
          ),
        ),
        onPressed: () {
          _showMyDialog(item);
        },
      ),
    );
  }

  /**
   * 修改弹窗在线编译补丁UI
   */
  Widget _buildOnlineModify(BuildContext context, ResListItemData? item) {
    return ListBody(children: [
      Row(children: [
        const Text('git地址:',
            style: TextStyle(fontSize: 14, color: Color(0xFF101010))),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
                width: 400,
                // child: Text(
                //   '${item?.patchGitUrl}',
                //   style: const TextStyle(
                //     fontSize: 14,
                //     color: Color(0xFF999999),
                //   ),
                // )))
                child: TextField(
                  controller: controllerGitUrl,
                  decoration: InputDecoration(
                      hintStyle: const TextStyle(
                          fontSize: 14, color: Color(0xFF888888)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      labelText: '${item?.patchGitUrl}'),
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF101010)),
                )))
      ]),
      const SizedBox(height: 20.0),
      Row(children: [
        const Text('git分支:',
            style: TextStyle(fontSize: 14, color: Color(0xFF101010))),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
                width: 400,
                child: TextField(
                  controller: controllerBranch,
                  decoration: InputDecoration(
                      hintStyle: const TextStyle(
                          fontSize: 14, color: Color(0xFF888888)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      labelText: '${item?.patchGitBranch}'),
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF101010)),
                )))
      ]),
      const SizedBox(height: 20.0),
      Row(children: [
        const Text('flut版本:',
            style: TextStyle(fontSize: 14, color: Color(0xFF101010))),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
                width: 400,
                child: TextField(
                  controller: controllerFluVer,
                  decoration: InputDecoration(
                      hintStyle: const TextStyle(
                          fontSize: 14, color: Color(0xFF888888)),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      labelText: '${item?.flutterVersion}'),
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF101010)),
                )))
      ]),
    ]);
  }

  /**
   * 修改弹窗本地上传文件补丁UI
   */
  Widget _buildLocalFileModify(BuildContext context, ResListItemData? item,
      void Function(void Function()) setState) {
    return ListBody(children: [
      Row(children: [
        const Text('选择文件:',
            style: TextStyle(fontSize: 14, color: Color(0xFF101010))),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SizedBox(
                width: 260,
                child: Text(
                  pubViewModel?.uploadFileTip ?? "",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ))),
        Container(
          width: 100,
          height: 35,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Color(0xFF999999),
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: GestureDetector(
            onTap: () {
              var name = item?.bundle_name;
              var ver = item?.bundle_version;

              if (controllerName.text.isNotEmpty) {
                name = controllerName.text;
              }
              if (controllerVer.text.isNotEmpty) {
                ver = controllerVer.text;
              }

              if (name!.isEmpty || ver!.isEmpty) {
                Fluttertoast.showToast(
                    msg: "请输入模块名称和版本",
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    webBgColor: '#000000',
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                pubViewModel?.showFile(name, ver, setState);
              }
            },
            child: const Text(
              "选择文件",
              style: TextStyle(fontSize: 15, color: Color(0xFFFFFFFF)),
            ),
          ),
        )
      ])
    ]);
  }

  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerVer = TextEditingController();
  TextEditingController controllerUrl = TextEditingController();
  TextEditingController controllerRemark = TextEditingController();
  TextEditingController controllerGitUrl = TextEditingController();
  TextEditingController controllerBranch = TextEditingController();
  TextEditingController controllerFluVer = TextEditingController();
  bool isOnlineBuild = true;

  /**
   * 编辑弹窗Dialog
   */
  Future<void> _showMyDialog(ResListItemData? item) async {
    controllerName = TextEditingController();
    controllerVer = TextEditingController();
    controllerUrl = TextEditingController();
    controllerRemark = TextEditingController();
    controllerGitUrl = TextEditingController();
    controllerBranch = TextEditingController();
    controllerFluVer = TextEditingController();
    isOnlineBuild = true;
    pubViewModel?.clearData();

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder:
            (BuildContext context, void Function(void Function()) setState) {
          return AlertDialog(
            title: const Text("修改数据"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('在线编译',
                          style: TextStyle(
                              fontSize: 14, color: Color(0xFF101010))),
                      const SizedBox(width: 20.0),
                      Switch(
                        value: isOnlineBuild,
                        activeColor: blue,
                        activeTrackColor: blue,
                        inactiveThumbColor: blue,
                        inactiveTrackColor: gray,
                        onChanged: (bool val) {
                          setState(() {
                            isOnlineBuild = !isOnlineBuild;
                          });
                          print("---isOnlineBuild：${isOnlineBuild}");
                        },
                      ),
                      const SizedBox(width: 100.0),
                    ],
                  ),
                  Row(children: [
                    const Text('名    字:',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF101010))),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                            width: 400,
                            child: TextField(
                              controller: controllerName,
                              decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                      fontSize: 14, color: Color(0xFF888888)),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0))),
                                  labelText: '${item?.bundle_name}'),
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF101010)),
                            )))
                  ]),
                  const SizedBox(height: 20.0),
                  Row(children: [
                    const Text('版    本:',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF101010))),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                            width: 400,
                            child: TextField(
                              controller: controllerVer,
                              decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                      fontSize: 14, color: Color(0xFF888888)),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0))),
                                  labelText: '${item?.bundle_version}'),
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF101010)),
                            )))
                  ]),
                  const SizedBox(height: 20.0),
                  Row(children: [
                    const Text('链    接:',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF101010))),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                            width: 400,
                            child: Text(
                              '${item?.patch_url}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF999999),
                              ),
                            )))
                  ]),
                  const SizedBox(height: 20.0),
                  Row(children: [
                    const Text('备    注:',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF101010))),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                            width: 400,
                            child: TextField(
                              controller: controllerRemark,
                              decoration: InputDecoration(
                                  hintStyle: const TextStyle(
                                      fontSize: 14, color: Color(0xFF888888)),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0))),
                                  labelText: '${item?.remark}'),
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xFF101010)),
                            )))
                  ]),
                  const SizedBox(height: 20.0),
                  isOnlineBuild
                      ? _buildOnlineModify(context, item)
                      : _buildLocalFileModify(context, item, setState)
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text('修改'),
                onPressed: () {
                  modifyPatch(item);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  /**
   * 请求资源修改接口
   */
  Future<void> modifyPatch(ResListItemData? item) async {
    var bundle_id = item?.bundle_id?.toString();
    var name = item?.bundle_name;
    var ver = item?.bundle_version;
    var url = item?.patch_url;
    var status = item?.status;
    var remark = item?.remark;
    var gitUrl = item?.patchGitUrl;
    var gitBranch = item?.patchGitBranch;
    var fluVer = item?.flutterVersion;

    if (controllerName.text.isNotEmpty) {
      name = controllerName.text;
    }
    if (controllerVer.text.isNotEmpty) {
      ver = controllerVer.text;
    }
    if (controllerUrl.text.isNotEmpty) {
      url = controllerUrl.text;
    }
    if (controllerRemark.text.isNotEmpty) {
      remark = controllerRemark.text;
    }
    if (controllerGitUrl.text.isNotEmpty) {
      gitUrl = controllerGitUrl.text;
    }
    if (controllerBranch.text.isNotEmpty) {
      gitBranch = controllerBranch.text;
    }
    if (controllerFluVer.text.isNotEmpty) {
      fluVer = controllerFluVer.text;
    }

    print("---${bundle_id}\n"
        "${name}\n"
        "${ver}\n"
        "${url}\n"
        "${status}\n"
        "${remark}\n"
        "${gitUrl}\n"
        "${gitBranch}\n"
        "${fluVer}\n"
        "${isOnlineBuild}\n");

    BaseResult? result;
    if (isOnlineBuild) {
      result = await viewModel.modifyPatchOnLine(
          bundle_id!,
          name!,
          ver!,
          url!,
          status!,
          remark!,
          viewModel.appId.toString(),
          gitUrl!,
          gitBranch!,
          fluVer!);
    } else {
      result = await pubViewModel?.modifyPatchLocalFile(bundle_id!, name!, ver!,
          url!, status!, remark!, viewModel.appId.toString());
    }

    var code = result?.status;
    var message = result?.message;
    if (code == '0') {
      refreshData();
      Fluttertoast.showToast(
          msg: "修改补丁成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          webBgColor: '#000000',
          backgroundColor: black,
          textColor: white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          webBgColor: '#000000',
          backgroundColor: black,
          textColor: white,
          fontSize: 16.0);
    }
  }

  /**
   * 请求资源列表接口刷新数据
   */
  Future<void> refreshData() async {
    var params = {'appId': viewModel.appId.toString()};
    viewModel.getPatchList(params);
  }
}
