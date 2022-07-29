import 'package:fair_management_web/base/base_view.dart';
import 'package:fair_management_web/resmgr/res_mgr_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/widget/home_appbar_widget.dart';

class ResMgrPage extends StatefulWidget {
  final int appId;

  const ResMgrPage(BuildContext context, {Key? key, required this.appId})
      : super(key: key);

  @override
  State<ResMgrPage> createState() => _ResMgrPageState();
}

class _ResMgrPageState extends State<ResMgrPage> {
  late ResMgrViewModel viewModel;

  @override
  void initState() {
    super.initState();
    debugPrint(widget.appId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<ResMgrViewModel>(
        model: ResMgrViewModel(api: Provider.of(context),appId: widget.appId),
        onModelReady: (model) {
          viewModel = model;
        },
        builder: (context, model, child) {
          return Material(
            child: Column(
              children: [
                const HomeAppBarWidget(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            for (int i = 0; i < ResMgrViewModel.pageList.length; i++)
                              _buttonWidget(index: i),
                          ],
                        ),
                      ),
                      dividerWidget(),
                      getContentPage(),
                    ],
                  ),
                ),
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
    Map item = ResMgrViewModel.pageList[index];
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
