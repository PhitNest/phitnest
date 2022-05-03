import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  bool _loading = true;

  bool get loading => _loading;

  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }
}
