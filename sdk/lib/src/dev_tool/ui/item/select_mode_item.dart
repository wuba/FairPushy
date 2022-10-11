import 'package:fair_pushy/src/dev_tool/base/dev_tool_item.dart';
import 'package:flutter/material.dart';

import '../../model/dev_tool_model.dart';

class DropSelectEnvItem extends StatelessWidget {
  const DropSelectEnvItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DevToolItem(
      title: "选择模式",
      child: ValueListenableBuilder<String?>(
          valueListenable: DevToolMode.of(context)!.selectMode,
          builder: (context, value, child) {
            return DropdownButton<String>(
                value: value,
                elevation: 1,
                icon: const Icon(
                  Icons.expand_more,
                  size: 20,
                ),
                items: _buildItems(context),
                onChanged: (String? select) => DevToolMode.of(context)!
                    .setSelectMode(
                        select ?? DevToolMode.of(context)!.selectMode.value));
          }),
    );
  }

  List<DropdownMenuItem<String>> _buildItems(BuildContext context) =>
      DevToolMode.of(context)!
          .modeList
          .map((e) => DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
              )))
          .toList();
}

class RadioSelectEnvItem extends StatelessWidget {
  const RadioSelectEnvItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DevToolItem(
      title: "选择环境",
      child: ValueListenableBuilder<String?>(
          valueListenable: DevToolMode.of(context)!.selectMode,
          builder: (context, value, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: DevToolMode.of(context)!
                  .modeList
                  .map((e) => Row(
                        children: [
                          Radio<String>(
                              value: e,
                              groupValue: value,
                              onChanged: (v) =>
                                  DevToolMode.of(context)!.selectMode.value =
                                      v ??
                                          DevToolMode.of(context)!
                                              .selectMode
                                              .value),
                          Text(e),
                        ],
                      ))
                  .toList(),
            );
          }),
    );
  }
}
