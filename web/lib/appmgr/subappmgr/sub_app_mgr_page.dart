import 'package:fair_management_web/appmgr/subappmgr/bean/app_list_data.dart';
import 'package:fair_management_web/appmgr/subappmgr/sub_app_mgr_view_model.dart';
import 'package:fair_management_web/base/base_view.dart';
import 'package:fair_management_web/common/base_ui.dart';
import 'package:fair_management_web/route/route_path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubAppMgrPage extends StatefulWidget {
  const SubAppMgrPage({Key? key}) : super(key: key);

  @override
  State<SubAppMgrPage> createState() => _SubAppMgrPageState();
}

class _SubAppMgrPageState extends State<SubAppMgrPage> {
  DateTime dateTime = DateTime.now();
  late SubAppMgrViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return BaseView<SubAppMgrViewModel>(
        model: SubAppMgrViewModel(api: Provider.of(context)),
        onModelReady: (model) {
          viewModel = model;
          model.isLoad = true;
          model.getAppList();
        },
        builder: (context, model, child) {
          if (viewModel.isLoad) {
            return SizedBox(
              height: 500,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(lightBlue),
                ),
              ),
            );
          }

          if (viewModel.appListData?.appList?.isEmpty ?? true) {
            return SizedBox(
              height: 500,
              child: Center(
                  child: Text(
                '暂无数据',
                style: TextStyle(fontSize: 15, color: black),
              )),
            );
          }

          return SizedBox(
            height: 500,
            child: CustomScrollView(
              controller: ScrollController(),
              slivers: [
                SliverToBoxAdapter(child: buildTable()),
              ],
            ),
          );
        });
  }

  Container buildTable() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Table(
        //所有列宽
        columnWidths: const {
          //列宽
          0: FlexColumnWidth(),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FlexColumnWidth(),
          4: FlexColumnWidth(),
        },
        //表格边框样式
        // border: TableBorder.all(
        //   color: Colors.green,
        //   width: 2.0,
        //   style: BorderStyle.solid,
        // ),
        children: [
          TableRow(
              decoration: BoxDecoration(
                color: gray,
              ),
              children: [
                buildItem('项目编号'),
                buildItem('项目名称'),
                buildItem('项目描述'),
                buildItem('创建时间'),
                buildItem('操作'),
              ]),
          for (var item in viewModel.appListData?.appList ?? [])
            _buildTableRow(item: item),
        ],
      ),
    );
  }

  Container buildItem(String? content) {
    return Container(
      height: 54,
      alignment: Alignment.center,
      child: SelectableText(
        content ?? '',
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF101010),
        ),
      ),
    );
  }

  TableRow _buildTableRow({required AppList item}) {
    return TableRow(children: [
      buildItem(item.appId?.toString()),
      buildItem(item.appName?.toString()),
      buildItem(item.appInfo?.toString()),
      buildItem(item.appCreateTime?.toString()),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   height: 54,
          //   alignment: Alignment.center,
          //   child: TextButton(
          //     child: Text(
          //       '编辑',
          //       style: TextStyle(
          //         fontSize: 14,
          //         color: lightBlue,
          //       ),
          //     ),
          //     onPressed: () {},
          //   ),
          // ),
          Container(
            height: 54,
            alignment: Alignment.center,
            child: TextButton(
              child: Text(
                '资源',
                style: TextStyle(
                  fontSize: 14,
                  color: lightBlue,
                ),
              ),
              onPressed: () {
                var uri = Uri(
                    scheme: 'fair',
                    host: RoutePath.appRes,
                    queryParameters: {"appId": item.appId?.toString() ?? ""});
                debugPrint("uri == " + uri.toString());
                Navigator.of(context).pushNamed(
                  uri.toString(),
                );
              },
            ),
          ),
        ],
      ),
    ]);
  }
}
