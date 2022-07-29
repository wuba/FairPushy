import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_view_model.dart';

class BaseView<T extends BaseViewModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget? child) builder;

  final T model;
  final Widget? child;
  final Function(T) onModelReady;

  const BaseView(
      {Key? key,
      required this.model,
      required this.builder,
      this.child,
      required this.onModelReady})
      : super(key: key);

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseViewModel> extends State<BaseView<T>> {
  late T model;

  @override
  void initState() {
    model = widget.model;
    widget.onModelReady(model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: ChangeNotifierProvider<T>(
        child: Consumer<T>(
          builder: widget.builder,
          child: widget.child,
        ),
        create: (BuildContext context) {
          return model;
        },
      ),
    );
  }
}
