import 'package:flutter/material.dart';

class ResSyncPage extends StatefulWidget {
  const ResSyncPage({Key? key}) : super(key: key);

  @override
  State<ResSyncPage> createState() => _ResSyncPageState();
}

class _ResSyncPageState extends State<ResSyncPage> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 500,
      child: Center(
        child: Text('资源同步功能,努力建设中...'),
      ),
    );
  }
}
