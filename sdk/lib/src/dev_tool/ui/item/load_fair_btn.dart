import 'package:fair_pushy/src/delegate.dart';
import 'package:fair_pushy/src/dev_tool/model/dev_tool_model.dart';
import 'package:fair_pushy/src/dev_tool/ui/bundle_list_page.dart';
import 'package:fair_pushy/src/dev_tool/utils/sp_utils.dart';
import 'package:flutter/material.dart';

class LoadFairBtn extends StatelessWidget {
  const LoadFairBtn({Key? key}) : super(key: key);

  /**
   * 加载bundle并跳转
   */
  Future _loadBundle(BuildContext context) async {
    final devToolMode = DevToolMode.of(context)!;
    String selectMode = devToolMode.selectMode.value;
    Code code;
    if (selectMode == DevToolMode.MODE_ONLINE) {
      code =
          await devToolMode.loadFairAssetsOnline(devToolMode.bundleId.value!);
      if (code == Code.success) {
        SPUtils.recordBundleIdByEnv(
            devToolMode.bundleId, devToolMode.selectOnlineEnv.value.envName);
      }
    } else {
      code = await devToolMode
          .loadFairAssetsLocal(devToolMode.localModeHost.value);
      if (code == Code.success) {
        SPUtils.recordLocalHost(devToolMode.localModeHost.value);
      }
    }
  }

  void _jumpBundle(BuildContext context) {
    final devToolMode = DevToolMode.of(context)!;
    String selectMode = devToolMode.selectMode.value;
    String? bundleId = null;
    if (selectMode == DevToolMode.MODE_ONLINE) {
      bundleId = devToolMode.bundleId.value!;
    }
    Navigator.of(context).push<void>(MaterialPageRoute(
        settings: RouteSettings(name: "BundleListPage"),
        builder: (context) {
          return BundleListPage(
            bundleId: bundleId,
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<SelectParamsInfo?>(
        valueListenable: DevToolMode.of(context)!.selectParamsNotifier,
        builder: (context, value, child) {
          return LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 15, right: 15, bottom: 15),
                  child: SizedBox(
                    height: 50,
                    child: MaterialButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.white,
                      onPressed: value == null ||
                              !value.completed ||
                              (value.completed && value.hasLoadedFairAssets)
                          ? null
                          : () async {
                              await _loadBundle(context);
                            },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(value?.loadFairText ?? ""),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Visibility(
                              visible: value?.isLoadingFairAssets == true,
                              child: const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                ///跳转bundle列表按钮
                Visibility(
                  visible: value != null && value.hasLoadedFairAssets,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 15, right: 15, bottom: 15),
                      child: SizedBox(
                        height: 50,
                        child: MaterialButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.white,
                          onPressed: () async {
                            _jumpBundle(context);
                          },
                          child: const Text("加载bundle"),
                        ),
                      ),
                    ),
                  ),
                ),

                ///清除缓存按钮
                Visibility(
                  visible: value != null && value.hasLoadedFairAssets,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 15, right: 15, bottom: 15),
                      child: SizedBox(
                        height: 50,
                        child: MaterialButton(
                          color: Colors.blue,
                          textColor: Colors.white,
                          disabledColor: Colors.grey,
                          disabledTextColor: Colors.white,
                          onPressed: () {
                            DevToolMode.of(context)!.notifyParamsChanged();
                          },
                          child: const Text("清除缓存"),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }
}
