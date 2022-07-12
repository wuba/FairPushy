import 'package:flutter/material.dart';

class Toast {
  static OverlayEntry? _overlayEntry;
  static bool _showing = false;
  static DateTime? _startedTime;
  static String? _msg;
  static double _showTime = 2000; //显示时长 2s
  static void toast(BuildContext context, String msg,
      {double showtime = 2000}) async {
    _msg = msg;
    _startedTime = DateTime.now();
    _showTime = showtime;

    OverlayState? overlayState = Overlay.of(context);
    _showing = true;
    if (_overlayEntry == null) {
      _overlayEntry =
          OverlayEntry(builder: (context) => _buildOverlayEntry(context));
      overlayState?.insert(_overlayEntry!);
    } else {
      //重新绘制UI，类似setState
      _overlayEntry?.markNeedsBuild();
    }
    await Future.delayed(const Duration(milliseconds: 2000));

    //2秒后 到底消失不消失
    if (DateTime.now().difference(_startedTime!).inMilliseconds >= _showTime) {
      _showing = false;
      _overlayEntry?.markNeedsBuild();
      await Future.delayed(const Duration(milliseconds: 400));
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  static Widget _buildOverlayEntry(BuildContext context) {
    return Positioned(
        top: MediaQuery.of(context).size.height * 2 / 3,
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0),
            child: AnimatedOpacity(
              opacity: _showing ? 1.0 : 0.0,
              duration: _showing
                  ? const Duration(microseconds: 100)
                  : const Duration(microseconds: 400),
              child: _buildToastWidget(),
            ),
          ),
        ));
  }

  static Widget _buildToastWidget() {
    return Center(
        child: Card(
            color: Colors.black26,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Text(_msg ?? "",
                    style: const TextStyle(
                        fontSize: 14.0, color: Colors.white)))));
  }
}
