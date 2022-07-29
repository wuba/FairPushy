import 'package:fair_management_web/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeListTitleWidget extends StatefulWidget {
  const HomeListTitleWidget({Key? key}) : super(key: key);

  @override
  _HomeListTitleWidgetState createState() => _HomeListTitleWidgetState();
}

class _HomeListTitleWidgetState extends State<HomeListTitleWidget> {
  late HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = Provider.of<HomeViewModel>(context);
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFFFFFFF)),
      width: 200,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 45,
              width: double.infinity,
              padding: const EdgeInsets.only(left: 25),
              child: Row(
                children: [
                  SizedBox(
                    child: Image.asset('images/icon_menu.png'),
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    '系统菜单',
                    style: TextStyle(fontSize: 14, color: Color(0x66000000)),
                  ),
                ],
              ),
            ),
            for (var item in HomeViewModel.appList) _buttonWidget(item: item),
          ],
        ),
      ),
    );
  }

  Widget _buttonWidget({required var item}) {
    bool isSelect = HomeViewModel.appList[viewModel.appMenuIndex] == item;
    Color typeColor =
        isSelect ? const Color(0xFFE6F7FF) : const Color(0xFFFFFFFF);
    Color textColor =
        isSelect ? const Color(0xFF1990FF) : const Color(0xFF000000);
    return GestureDetector(
      child: Container(
        height: 40,
        color: typeColor,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 50),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item['name'],
                style: TextStyle(fontSize: 14, color: textColor),
              ),
            ),
            isSelect
                ? Container(
                    width: 1,
                    color: const Color(0xFF1990ff),
                  )
                : Container()
          ],
        ),
      ),
      onTap: () {
        viewModel.appMenuClick(item);
      },
    );
    return Consumer<HomeViewModel>(builder: (_, viewModel, child) {});
  }
}
