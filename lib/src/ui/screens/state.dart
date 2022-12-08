import 'package:flutter/material.dart';

abstract class ScreenState extends ChangeNotifier {
  ScreenState() : super();

  bool _disposed = false;

  bool get disposed => _disposed;

  bool _initialized = false;

  bool get initialized => _initialized;

  set initialized(bool initialized) {
    _initialized = initialized;
    rebuildView();
  }

  void rebuildView() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
