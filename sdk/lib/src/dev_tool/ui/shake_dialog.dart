import 'package:fair_pushy/src/delegate.dart';
import 'package:fair_pushy/src/dev_tool/ui/bundle_list_page.dart';
import 'package:fair_pushy/src/dev_tool/utils/sp_utils.dart';
import 'package:flutter/material.dart';

typedef DismissCallback = void Function();

class ShakeDialog extends StatefulWidget {
  DismissCallback? onDismiss;

  ShakeDialog({Key? key, this.onDismiss}) : super(key: key);

  @override
  State<ShakeDialog> createState() => _ShakeDialogState(onDismiss);
}

class _ShakeDialogState extends State<ShakeDialog> {
  _ShakeDialogState(this.onDismiss);

  DismissCallback? onDismiss;

  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(),
      insetPadding: EdgeInsets.symmetric(),
      elevation: 0,
      content: GestureDetector(
        onTap: () {
          if (_loading) {
            return;
          }
          Navigator.of(context).pop();
        },
        child: Container(
            color: Colors.transparent,
            width: 400,
            child: Center(
                child: MaterialButton(
              color: Colors.white,
              height: 50,
              child: Container(
                width: 280,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Reload"),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Visibility(
                        visible: _loading,
                        child: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              onPressed: () async {
                if (_loading) {
                  return;
                }
                _reloadBundle();
              },
            ))),
      ),
    );
  }

  void _reloadBundle() async {
    changeLoadingState(true);
    final localHost = await SPUtils.getLocalHost();
    await Delegate.updateDebugFW(localHost!);
    changeLoadingState(false);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            settings: RouteSettings(name: "BundleListPage"),
            builder: (context) {
              return BundleListPage(
                bundleId: null,
              );
            }), (Route<dynamic> route) {
      return route.settings.name == "DevToolPage";
    });
    onDismiss?.call();
  }

  void changeLoadingState(bool isLoading) {
    setState(() {
      _loading = isLoading;
    });
  }

  @override
  void dispose() {
    super.dispose();
    onDismiss?.call();
  }
}
