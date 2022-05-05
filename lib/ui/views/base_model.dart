import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  late bool _loading;

  /// Setting initiallyLoading to true will cause the loading widget to be
  /// built. Setting [loading] to false will rebuild the view.
  BaseModel({bool initiallyLoading = false}) : _loading = initiallyLoading;

  bool get loading => _loading;

  /// Updating the value of [loading] to a new value will rebuild the view
  set loading(bool loading) {
    if (_loading != loading) {
      _loading = loading;
      notifyListeners();
    }
  }
}
