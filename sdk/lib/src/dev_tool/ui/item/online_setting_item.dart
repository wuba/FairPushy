import 'package:fair_pushy/src/dev_tool/base/dev_tool_item.dart';
import 'package:fair_pushy/src/dev_tool/model/dev_tool_model.dart';
import 'package:fair_pushy/src/dev_tool/utils/sp_utils.dart';
import 'package:flutter/material.dart';

class OnlineHostItem extends StatefulWidget {
  const OnlineHostItem({Key? key}) : super(key: key);

  @override
  State<OnlineHostItem> createState() => _OnlineHostItemState();
}

class _OnlineHostItemState extends State<OnlineHostItem> {
  late TextEditingController _UrlController;
  late TextEditingController _bundleIdController;

  @override
  void initState() {
    super.initState();
    _UrlController = TextEditingController();
    _bundleIdController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
        valueListenable: DevToolMode.of(context)!.selectMode,
        builder: (context, mode, child) {
          return ValueListenableBuilder<OnlineEnvInfo?>(
              valueListenable: DevToolMode.of(context)!.selectOnlineEnv,
              builder: (context, env, child) {
                final show = mode == DevToolMode.MODE_ONLINE && env != null;
                _UrlController.text = env?.updateUrl ?? "";
                if (show && env != null) {
                  SPUtils.getBundleIdByEnv(env.envName).then((value) {
                    DevToolMode.of(context)!.bundleId = value ?? "";
                    _bundleIdController.text = value ?? "";
                  });
                }
                return Visibility(
                    visible: show,
                    child: Column(
                      children: [
                        DevToolItem(
                          title: "url",
                          child: SizedBox(
                            width: 200,
                            child: TextField(
                              enabled: env?.readOnly == false,
                              controller: _UrlController,
                              style: TextStyle(
                                  color: env?.readOnly == true
                                      ? Colors.grey
                                      : null),
                              onChanged: (value) {
                                env?.updateUrl = value;
                                DevToolMode.of(context)!.notifyParamsChanged();
                              },
                            ),
                          ),
                        ),
                        DevToolItem(
                          title: "bundleId",
                          child: SizedBox(
                            width: 200,
                            child: TextField(
                              controller: _bundleIdController,
                              onChanged: (value) {
                                DevToolMode.of(context)!.bundleId = value;
                              },
                            ),
                          ),
                        )
                      ],
                    ));
              });
        });
  }
}

class LocalHostItem extends StatefulWidget {
  const LocalHostItem({Key? key}) : super(key: key);

  @override
  State<LocalHostItem> createState() => _LocalHostItemState();
}

class _LocalHostItemState extends State<LocalHostItem> {
  late TextEditingController _localHostController;

  @override
  void initState() {
    super.initState();
    _localHostController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
        valueListenable: DevToolMode.of(context)!.selectMode,
        builder: (context, mode, child) {
          final show = mode == DevToolMode.MODE_LOCAL;
          if (show) {
            SPUtils.getLocalHost()
                .then((value) => _localHostController.text = value ?? "");
          }
          return Visibility(
              visible: show,
              child: DevToolItem(
                title: "host",
                child: SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _localHostController,
                    onChanged: (value) {
                      DevToolMode.of(context)?.setLocalModeHost(value);
                    },
                  ),
                ),
              ));
        });
  }
}
