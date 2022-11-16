import 'package:fair_pushy/src/dev_tool/ui/scan_qr_code_page.dart';
import 'package:flutter/material.dart';

class ScanQrCodeBtn extends StatelessWidget {
  const ScanQrCodeBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Text('在Fair云开发平台上，点击右上角扫码预览，使用手机扫码预览在线编辑的Fair代码'),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 15),
          child: SizedBox(
            height: 50,
            child: MaterialButton(
              color: Colors.teal,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ScanQrCodePage(),
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Fair 云开发平台-扫码预览')],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
