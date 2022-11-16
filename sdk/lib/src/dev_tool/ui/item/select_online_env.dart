import 'package:fair_pushy/src/dev_tool/base/dev_tool_item.dart';
import 'package:fair_pushy/src/dev_tool/model/dev_tool_model.dart';
import 'package:flutter/material.dart';

class DropSelectOnlineEnvItem extends StatelessWidget {
  const DropSelectOnlineEnvItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
        valueListenable: DevToolMode.of(context)!.selectMode,
        builder: (context, mode, child) {
          return Visibility(
            visible: mode == DevToolMode.MODE_ONLINE,
            child: DevToolItem(
              title: "选择环境",
              child: ValueListenableBuilder<OnlineEnvInfo?>(
                  valueListenable: DevToolMode.of(context)!.selectOnlineEnv,
                  builder: (context, value, child) {
                    return DropdownButton<OnlineEnvInfo>(
                        value: value,
                        elevation: 1,
                        icon: const Icon(
                          Icons.expand_more,
                          size: 20,
                        ),
                        items: _buildItems(context),
                        onChanged: (OnlineEnvInfo? select) =>
                            DevToolMode.of(context)!.setSelectOnlineEnv(
                                select ??
                                    DevToolMode.of(context)!
                                        .selectOnlineEnv
                                        .value));
                  }),
            ),
          );
        });
  }

  List<DropdownMenuItem<OnlineEnvInfo>> _buildItems(BuildContext context) =>
      DevToolMode.of(context)!
          .envList
          .map((e) => DropdownMenuItem<OnlineEnvInfo>(
              value: e,
              child: Text(
                e.envName,
              )))
          .toList();
}
