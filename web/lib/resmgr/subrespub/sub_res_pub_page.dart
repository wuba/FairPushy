import 'package:fair_management_web/base/base_view.dart';
import 'package:fair_management_web/network/base_result.dart';
import 'package:fair_management_web/resmgr/res_mgr_view_model.dart';
import 'package:fair_management_web/resmgr/subrespub/sub_res_pub_view_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../common/base_ui.dart';

class SubResPubPage extends StatefulWidget {
  const SubResPubPage({Key? key}) : super(key: key);

  @override
  State<SubResPubPage> createState() => _SubResPubPageState();
}

class _SubResPubPageState extends State<SubResPubPage> {
  late SubResPubViewModel viewModel;
  bool isOnlineBuild = true;
  ResMgrViewModel? resMgrViewModel;
  final TextEditingController _versionController = TextEditingController();
  final TextEditingController _moduleNameController = TextEditingController();
  final TextEditingController _patchMarkController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _gitBranchController = TextEditingController();
  final TextEditingController _gitUrlController = TextEditingController();
  final TextEditingController _flutterVersionController =
      TextEditingController();

  final TextStyle fieldStyle =
      const TextStyle(fontSize: 14, color: Color(0xFF101010));

  @override
  Widget build(BuildContext context) {
    resMgrViewModel = Provider.of(context);
    ResMgrViewModel model = Provider.of<ResMgrViewModel>(context);
    return BaseView<SubResPubViewModel>(
      model: SubResPubViewModel(
        api: Provider.of(context),
        appId: model.appId,
      ),
      onModelReady: (model) {
        viewModel = model;
      },
      builder: (context, model, child) {
        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        _buildSwitchContent(context),
        isOnlineBuild
            ? _buildOnlineContentView(context)
            : _buildLocalContentView(context),
      ],
    );
  }

  Row _buildSwitchContent(BuildContext context) {
    var widgets = <Widget>[
      const SizedBox(width: 20),
      Text('在线编译', style: fieldStyle),
      const SizedBox(width: 20.0),
      Switch(
          value: isOnlineBuild,
          activeColor: blue,
          activeTrackColor: blue,
          inactiveThumbColor: blue,
          inactiveTrackColor: gray,
          onChanged: (value) {
            isOnlineBuild = !isOnlineBuild;
            setState(() {});
          }),
      const SizedBox(width: 100.0),
    ];
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center, children: widgets);
  }

  Container _buildOnlineContentView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('模块名称', style: fieldStyle),
                const SizedBox(width: 20.0),
                SizedBox(
                  width: 300,
                  height: 60,
                  child: TextField(
                      controller: _moduleNameController,
                      minLines: 1,
                      maxLines: 1,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 0, bottom: 0, left: 10),
                        hintText: '请输入模块名称',
                        hintStyle:
                            TextStyle(fontSize: 14, color: Color(0xFF888888)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                      ),
                      style: fieldStyle),
                ),
                const SizedBox(
                  width: 150,
                ),
                Text('编译版本', style: fieldStyle),
                const SizedBox(width: 20.0),
                SizedBox(
                  width: 300,
                  height: 60,
                  child: TextField(
                      controller: _flutterVersionController,
                      minLines: 1,
                      maxLines: 1,
                      maxLength: 20,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.only(top: 0, bottom: 0, left: 10),
                        hintText: '请输入编译Flutter版本',
                        hintStyle:
                            TextStyle(fontSize: 14, color: Color(0xFF888888)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                      ),
                      style: fieldStyle),
                )
              ]),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('模块版本'),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 300,
                height: 60,
                child: TextField(
                  controller: _versionController,
                  minLines: 1,
                  maxLines: 1,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 0, bottom: 0, left: 10),
                    hintText: '请输入模块版本',
                    hintStyle:
                        TextStyle(fontSize: 14, color: Color(0xFF888888)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                  ),
                  style: fieldStyle,
                ),
              ),
              const SizedBox(
                width: 150,
              ),
              const Text('git地址   '),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 300,
                height: 60,
                child: TextField(
                  controller: _gitUrlController,
                  minLines: 1,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 0, bottom: 0, left: 10),
                    hintText: '请输入在线编译Git地址',
                    hintStyle:
                        TextStyle(fontSize: 14, color: Color(0xFF888888)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                  ),
                  style: fieldStyle,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('补丁备注'),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 300,
                height: 100,
                child: TextField(
                  controller: _patchMarkController,
                  decoration: const InputDecoration(
                    hintText: '输入备注信息',
                    hintStyle:
                        TextStyle(fontSize: 14, color: Color(0xFF888888)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                  ),
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF101010)),
                  minLines: 5,
                  maxLines: 5,
                  maxLength: 250,
                ),
              ),
              const SizedBox(
                width: 150,
              ),
              const Text('分支名   '),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 300,
                height: 60,
                child: TextField(
                  controller: _gitBranchController,
                  minLines: 1,
                  maxLines: 1,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 0, bottom: 0, left: 10),
                    hintText: '请输入在线编译git分支名',
                    hintStyle:
                        TextStyle(fontSize: 14, color: Color(0xFF888888)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                  ),
                  style: fieldStyle,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          _buildSubmitContent(),
        ],
      ),
    );
  }

  Container _buildLocalContentView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('模块名称', style: fieldStyle),
              const SizedBox(width: 20.0),
              SizedBox(
                width: 300,
                height: 60,
                child: TextField(
                    controller: _moduleNameController,
                    minLines: 1,
                    maxLines: 1,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.only(top: 0, bottom: 0, left: 10),
                      hintText: '请输入模块名称',
                      hintStyle:
                          TextStyle(fontSize: 14, color: Color(0xFF888888)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    ),
                    style: fieldStyle),
              ),
              const SizedBox(
                width: 150,
              ),
              const Text('补丁链接'),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 300,
                height: 60,
                child: TextField(
                  controller: _urlController,
                  minLines: 1,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 0, bottom: 0, left: 10),
                    hintText: '请输入补丁链接(上传文件可以不填此项)',
                    hintStyle:
                        TextStyle(fontSize: 14, color: Color(0xFF888888)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                  ),
                  style: fieldStyle,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('模块版本'),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 300,
                height: 60,
                child: TextField(
                  controller: _versionController,
                  minLines: 1,
                  maxLines: 1,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.only(top: 0, bottom: 0, left: 10),
                    hintText: '请输入模块版本',
                    hintStyle:
                        TextStyle(fontSize: 14, color: Color(0xFF888888)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                  ),
                  style: fieldStyle,
                ),
              ),
              const SizedBox(
                width: 150,
              ),
              const Text('选择文件'),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                  width: 200,
                  child: Text(
                    viewModel.uploadFileTip,
                    style: const TextStyle(fontSize: 13.0, color: Colors.grey),
                  )),
              Container(
                width: 80,
                height: 35,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFF999999),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: GestureDetector(
                  onTap: () {
                    if (_versionController.text.isEmpty ||
                        _moduleNameController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "请输入模块名和版本",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER_LEFT,
                          timeInSecForIosWeb: 1,
                          webBgColor: '#000000',
                          backgroundColor: black,
                          textColor: white,
                          fontSize: 16.0);
                    } else {
                      viewModel.showFile(
                          _moduleNameController.text, _versionController.text);
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4091F7),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: const Text(
                      '选择文件',
                      style: TextStyle(fontSize: 15, color: Color(0xFFFFFFFF)),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('补丁备注'),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                width: 300,
                height: 100,
                child: TextField(
                  controller: _patchMarkController,
                  decoration: const InputDecoration(
                    hintText: '输入备注信息',
                    hintStyle:
                        TextStyle(fontSize: 14, color: Color(0xFF888888)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3))),
                  ),
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF101010)),
                  minLines: 5,
                  maxLines: 5,
                  maxLength: 250,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          _buildSubmitContent(),
        ],
      ),
    );
  }

  Container _buildSubmitContent() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              if (isOnlineBuild) {
                createPatchAndBuild();
              } else {
                createPatch();
              }
            },
            child: Container(
              width: 100,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFF4091F7),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: const Text(
                '创建补丁',
                style: TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> createPatchAndBuild() async {
    BaseResult? result = await viewModel.createAndBuildPatch(
      _versionController.text,
      viewModel.appId.toString(),
      _patchMarkController.text,
      _moduleNameController.text,
      _gitUrlController.text,
      _gitBranchController.text,
      _flutterVersionController.text,
    );
    var resultData = result?.status ?? "-1";
    if (resultData == "0") {
      Fluttertoast.showToast(
          msg: "创建补丁成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 1,
          webBgColor: '#000000',
          backgroundColor: black,
          textColor: white,
          fontSize: 16.0);

      resMgrViewModel?.clickTabByName('资源管理');
      return;
    } else {
      Fluttertoast.showToast(
          msg: "创建补丁失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 1,
          webBgColor: '#000000',
          backgroundColor: black,
          textColor: white,
          fontSize: 16.0);
      return;
    }
  }

  Future<void> createPatch() async {
    BaseResult? result = await viewModel.createPatch(
        _versionController.text,
        viewModel.appId.toString(),
        _patchMarkController.text,
        _moduleNameController.text,
        _urlController.text,
        true);
    var resultData = result?.status ?? "-1";
    if (resultData == "0") {
      Fluttertoast.showToast(
          msg: "创建补丁成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 1,
          webBgColor: '#000000',
          backgroundColor: black,
          textColor: white,
          fontSize: 16.0);

      resMgrViewModel?.clickTabByName('资源管理');
      return;
    } else {
      Fluttertoast.showToast(
          msg: "创建补丁失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM_RIGHT,
          timeInSecForIosWeb: 1,
          webBgColor: '#000000',
          backgroundColor: black,
          textColor: white,
          fontSize: 16.0);
      return;
    }
  }
}
