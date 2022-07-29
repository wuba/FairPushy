import 'package:flutter/cupertino.dart';

class ResBuildPage extends StatefulWidget {
  const ResBuildPage({Key? key}) : super(key: key);

  @override
  State<ResBuildPage> createState() => _ResBuildPageState();
}

class _ResBuildPageState extends State<ResBuildPage> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 500,
      child: Center(
        child: Text('资源构建功能,努力建设中...'),
      ),
    );
  }
}
