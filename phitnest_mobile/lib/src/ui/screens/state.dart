import 'package:flutter/material.dart';

abstract class ScreenState extends ChangeNotifier {
  bool _initialized = false;

  bool get initialized => _initialized;

  set initialized(bool initialized) {
    _initialized = initialized;
    rebuildView();
  }

  rebuildView() => notifyListeners();
}
