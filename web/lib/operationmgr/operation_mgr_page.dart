import 'package:flutter/material.dart';

class OperationMgrPage extends StatefulWidget {
  const OperationMgrPage({Key? key}) : super(key: key);

  @override
  State<OperationMgrPage> createState() => _OperationMgrPageState();
}

class _OperationMgrPageState extends State<OperationMgrPage> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 500,
      child: Center(
        child: Text('操作记录功能,努力建设中...'),
      ),
    );
  }
}
