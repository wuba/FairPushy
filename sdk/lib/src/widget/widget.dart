import 'package:flutter/material.dart';
import '../delegate.dart';
import '../../fair_pushy.dart';
import 'page_builder.dart';
import 'toast.dart';

/*
两个module间的界面跳转中间件
自动处理下载相关流程
*/
typedef OnUpdateFailure = void Function(Code code);

class FairPushyWidget extends StatefulWidget {
  //module唯一标识
  final String bundleid;
  //目标页面的pageame
  final String? targetPageName;
  //目标页面widget
  final WidgetBuilder? targetWidgetBuilder;
  //目标页面的传入参数
  final dynamic params;
  //占位widget，下载时的loading界面，可单个传入，也可在FairPushy中全局注入
  final WidgetBuilder? placeholder;
  //请求发生错误时回调
  final OnUpdateFailure? onError;
  //是否显示错误toast，默认显示
  final bool showErrorToast;

  const FairPushyWidget(
      {Key? key,
      required this.bundleid,
      this.targetPageName,
      this.targetWidgetBuilder,
      this.placeholder,
      this.params,
      this.onError,
      this.showErrorToast = true})
      : assert(!(targetPageName == null && targetWidgetBuilder == null),
            'pageName and routerWidget at least one exists'),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<FairPushyWidget> {
  Widget? _child;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    FairPushy.updateBundle(bundleId: widget.bundleid).then((code) {
      if (widget.onError != null) {
        widget.onError!(code);
      }
      showToast(code);
      if (widget.targetWidgetBuilder != null) {
        _child = widget.targetWidgetBuilder!(context);
      } else if (widget.targetPageName != null) {
        String path = widget.targetPageName!;
        FPageBuilder? widgetBuilder = PageBuilder.instance.getBuilder(path);
        if (widgetBuilder != null) {
          _child = widgetBuilder(context, widget.params);
        } else {
          Toast.toast(context, '没找到目标页');
          Navigator.pop(context);
          return;
        }
      }
      setState(() {});
      if (_child == null) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    var builder = widget.placeholder ?? PageBuilder.instance.placeholderBuilder;
    var result = _child ?? builder(context);
    return result;
  }

  //出错提示
  void showToast(Code code) {
    if (code != Code.success && widget.showErrorToast) {
      switch (code) {
        case Code.getConfigError:
          Toast.toast(context, "获取config文件出错啦~");
          break;
        case Code.downloadError:
          Toast.toast(context, "下载错误啦~");
          break;
        case Code.unZipError:
          Toast.toast(context, "解压失败啦~");
          break;
        case Code.downloadTimeOut:
          Toast.toast(context, "下载超时啦~");
          break;
        case Code.getConfigTimeOut:
          Toast.toast(context, "请求config超时啦~");
          break;
        default:
          Toast.toast(context, "未知错误");
          break;
      }
    }
  }
}
