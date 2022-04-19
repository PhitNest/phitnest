import 'package:flutter/material.dart';

class AppModel extends ChangeNotifier {
  bool _initialized = false;

  bool _error = false;

  set initialized(initialized) {
    _initialized = initialized;
    notifyListeners();
  }

  set error(error) {
    _error = error;
    notifyListeners();
  }

  bool get initialized => _initialized;

  bool get error => _error;
}
