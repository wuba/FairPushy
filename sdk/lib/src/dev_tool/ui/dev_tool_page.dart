import 'package:fair_pushy/src/dev_tool/fair_dev_tool.dart';
import 'package:fair_pushy/src/dev_tool/ui/item/load_fair_btn.dart';
import 'package:fair_pushy/src/dev_tool/ui/item/scan_qr_code_btn.dart';
import 'package:flutter/material.dart';

import '../model/dev_tool_model.dart';
import 'item/online_setting_item.dart';
import 'item/select_mode_item.dart';
import 'item/select_online_env.dart';

class DevToolPage extends StatefulWidget {
  DevToolPage({Key? key}) : super(key: key);

  @override
  State<DevToolPage> createState() => _DevToolPageState();
}

class _DevToolPageState extends State<DevToolPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fair开发者选项"),
      ),
      body: DevToolMode(
        config: FairDevTools.config,
        child: _buildToolList(),
      ),
    );
  }

  Widget _buildToolList() {
    return ListView(
      children: const [
        ///下拉选择模式
        DropSelectEnvItem(),

        ///下拉选择线上环境
        DropSelectOnlineEnvItem(),

        ///线上环境host
        OnlineHostItem(),

        ///本地环境host
        LocalHostItem(),

        ///加载按钮
        LoadFairBtn(),

        ///Fair云开发平台扫码
        ScanQrCodeBtn(),
      ],
    );
  }
}
