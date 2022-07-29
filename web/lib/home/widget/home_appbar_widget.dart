import 'package:cached_network_image/cached_network_image.dart';
import 'package:fair_management_web/common/base_ui.dart';
import 'package:fair_management_web/route/route_path.dart';
import 'package:flutter/material.dart';

class HomeAppBarWidget extends StatefulWidget {
  const HomeAppBarWidget({Key? key}) : super(key: key);

  @override
  _HomeAppBarWidgetState createState() => _HomeAppBarWidgetState();
}

class _HomeAppBarWidgetState extends State<HomeAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: double.infinity,
      color: blue,
      child: Row(
        children: [
          const SizedBox(width: 10),
          GestureDetector(
            child: Text('Flutter热更新平台',
                style: TextStyle(fontSize: 18, color: white)),
            onTap: () {
              var uri = Uri(
                scheme: 'fair',
                host: RoutePath.home,
              );
              Navigator.of(context).pushNamed(
                uri.toString(),
              );
            },
          ),
          const Expanded(
              child: SizedBox(
            width: 1,
          )),
          ClipOval(
            child: CachedNetworkImage(
                width: 25,
                height: 25,
                placeholder: (context, url) =>
                    Image.asset('images/icon_default_user_head.png'),
                errorWidget: (context, url, error) =>
                    Image.asset('images/icon_default_user_head.png'),
                fit: BoxFit.cover,
                imageUrl: ''),
          ),
          const SizedBox(width: 10),
          Text('用户名', style: TextStyle(fontSize: 14, color: white)),
          const SizedBox(width: 20)
        ],
      ),
    );
  }
}
