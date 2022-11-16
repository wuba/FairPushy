import 'package:flutter/material.dart';

class DevToolItem extends StatelessWidget {
  String? title;
  Widget? child;

  DevToolItem({Key? key, this.title, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 15),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Align(
              alignment: Alignment.center,
              child: title?.isNotEmpty == true ? Text(title!) : Container(),
            ),
          ),
          Padding(
            padding: title?.isNotEmpty == true
                ? const EdgeInsets.only(left: 15)
                : EdgeInsets.zero,
            child: child == null ? Container() : child!,
          ),
        ],
      ),
    );
  }
}
