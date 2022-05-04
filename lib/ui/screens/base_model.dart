import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  late bool _loading;

  BaseModel({bool initiallyLoading = false}) {
    _loading = initiallyLoading;
  }

  bool get loading => _loading;

  set loading(bool loading) {
    if (_loading != loading) {
      _loading = loading;
      notifyListeners();
    }
  }
}
