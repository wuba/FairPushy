import 'package:fair_management_web/base/base_view.dart';
import 'package:fair_management_web/common/base_ui.dart';
import 'package:fair_management_web/home/home_view_model.dart';
import 'package:fair_management_web/home/widget/home_appbar_widget.dart';
import 'package:fair_management_web/home/widget/home_list_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
        model: HomeViewModel(api: Provider.of(context)),
        onModelReady: (model) {
          viewModel = model;
        },
        builder: (context, model, child) {
          return Material(
            color: white,
            child: Column(
              children: [
                appBarWidget(),
                contentWidget(),
              ],
            ),
          );
        });
  }

  //顶部appBar
  Widget appBarWidget() {
    return const HomeAppBarWidget();
  }

  //内容 widget
  Widget contentWidget() {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          contentLeftListWidget(),
          dividerWidget(),
          contentRightFormWidget(),
        ],
      ),
    );
  }

  ///分割线
  Widget dividerWidget() {
    return Container(
      width: 0.1,
      color: const Color(0xFF333333),
    );
  }

  ///一级列表
  Widget contentLeftListWidget() {
    return const HomeListTitleWidget();
  }

  ///内容显示部分
  Widget contentRightFormWidget() {
    var currentPage = viewModel.getCurrentPage();
    return Expanded(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 45,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            color: gray,
            child: Text(viewModel.getCurrentPageName(),
                style: const TextStyle(color: Color(0x66000000), fontSize: 14)),
          ),
          currentPage ?? Container()
        ],
      ),
    );
  }
}
