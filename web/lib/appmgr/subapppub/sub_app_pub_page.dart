import 'dart:ui';

import 'package:fair_management_web/appmgr/subapppub/sub_app_pub_view_model.dart';
import 'package:fair_management_web/base/base_view.dart';
import 'package:fair_management_web/common/base_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubAppPubPage extends StatefulWidget {
  const SubAppPubPage({Key? key}) : super(key: key);

  @override
  State<SubAppPubPage> createState() => _SubAppPubPageState();
}

class _SubAppPubPageState extends State<SubAppPubPage> {
  late SubAppPubViewModel viewModel;
  TextEditingController? controllerName;
  TextEditingController? controllerDes;

  @override
  void initState() {
    super.initState();
    controllerName = TextEditingController();
    controllerDes = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<SubAppPubViewModel>(
        model: SubAppPubViewModel(
            api: Provider.of(context), appMgrViewModel: Provider.of(context)),
        onModelReady: (model) {
          viewModel = model;
        },
        builder: (context, model, child) {
          controllerName?.text = model.appName ?? '';
          controllerDes?.text = model.appDes ?? '';
          return Container(
            width: 550,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('应用名称：',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF101010))),
                    const SizedBox(width: 20.0),
                    SizedBox(
                      width: 400,
                      child: TextField(
                        controller: controllerName,
                        minLines: 1,
                        maxLines: 1,
                        maxLength: 10,
                        onChanged: (str) {
                          model.appName = str;
                        },
                        decoration: const InputDecoration(
                          hintText: '应用名称',
                          hintStyle:
                              TextStyle(fontSize: 14, color: Color(0xFF888888)),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                        ),
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF101010)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('备注：',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF101010))),
                    const SizedBox(width: 20.0),
                    SizedBox(
                      width: 400,
                      child: TextField(
                        controller: controllerDes,
                        onChanged: (str) {
                          model.appDes = str;
                        },
                        decoration: const InputDecoration(
                          hintText: '输入备注信息',
                          hintStyle:
                              TextStyle(fontSize: 14, color: Color(0xFF888888)),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                        ),
                        style: const TextStyle(
                            fontSize: 14, color: Color(0xFF101010)),
                        minLines: 5,
                        maxLines: 5,
                        maxLength: 250,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 110.0,
                    ),
                    Container(
                      width: 80,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: blue,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: TextButton(
                        child: Text(
                          '添加',
                          style: TextStyle(fontSize: 16, color: white),
                        ),
                        onPressed: () {
                          var name = controllerName?.text;
                          var des = controllerDes?.text;
                          viewModel.createApp(name, des, "");
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Container(
                      width: 80,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: lightBlack, width: 0.5),
                        color: white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: TextButton(
                        child: Text(
                          '取消',
                          style: TextStyle(fontSize: 16, color: lightBlack),
                        ),
                        onPressed: () {
                          model.cancelCreate();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
