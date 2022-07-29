import 'package:fair_management_web/base/view_state.dart';
import 'package:flutter/material.dart';

import '../common/api.dart';

class BaseViewModel extends ChangeNotifier {
  Api api;
  bool disposed = false;

  BaseViewModel({required this.api});

  ViewState _state = ViewState.idle;

  ViewState get state => _state;

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    disposed = true;
  }

  @override
  void notifyListeners() {
    if (!disposed) {
      super.notifyListeners();
    }
  }
}
