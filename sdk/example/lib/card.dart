import 'package:example/const.dart';
import 'package:flutter/material.dart';

class FCard extends StatelessWidget {
  final Color? bgColor;
  final String? title;
  FCard({this.bgColor, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (screenWidth(context) - 20) / 2,
      height: 150,
      margin: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)), color: bgColor),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          title ?? "title",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
