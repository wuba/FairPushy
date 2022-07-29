import 'package:fair_management_web/appmgr/app_mgr_view_model.dart';
import 'package:fair_management_web/base/base_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppMgrPage extends StatefulWidget {
  const AppMgrPage({Key? key}) : super(key: key);

  @override
  State<AppMgrPage> createState() => _AppMgrPageState();
}

class _AppMgrPageState extends State<AppMgrPage> {
  late AppMgrViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseView<AppMgrViewModel>(
        model: AppMgrViewModel(api: Provider.of(context)),
        onModelReady: (model) {
          viewModel = model;
        },
        builder: (context, model, child) {
          return Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      for (int i = 0; i < AppMgrViewModel.pageList.length; i++)
                        _buttonWidget(index: i)
                    ],
                  ),
                ),
                dividerWidget(),
                getContentPage(),
              ],
            ),
          );
        });
  }

  ///分割线
  Widget dividerWidget() {
    return Container(
      height: 0.1,
      color: const Color(0xFF333333),
    );
  }

  Widget _buttonWidget({required int index}) {
    Map item = AppMgrViewModel.pageList[index];
    bool isSelect = viewModel.index == index;
    Color textColor =
        isSelect ? const Color(0xFF1990FF) : const Color(0xFF000000);
    return GestureDetector(
      child: SizedBox(
        width: 90,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: Text(item['name'],
                  style: TextStyle(fontSize: 14, color: textColor)),
            ),
            isSelect
                ? Container(
                    height: 1,
                    color: const Color(0xFF1990ff),
                  )
                : Container()
          ],
        ),
      ),
      onTap: () {
        viewModel.clickTab(index);
      },
    );
  }

  Widget getContentPage() {
    return viewModel.getCurrentPage() ?? Container();
  }
}
