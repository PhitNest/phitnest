import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

abstract class ScreenState extends ChangeNotifier {
  final KeyboardVisibilityController keyboardController =
      KeyboardVisibilityController();

  late final StreamSubscription<bool> _keyboardListener =
      keyboardController.onChange.listen((visible) {
    _keyboardVisible = visible;
    rebuildView();
  });

  ScreenState() : super();

  bool _disposed = false;

  bool _initialized = false;

  bool get initialized => _initialized;

  set initialized(bool initialized) {
    _initialized = initialized;
    rebuildView();
  }

  bool _keyboardVisible = false;

  bool get keyboardVisible => _keyboardVisible;

  void rebuildView() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _keyboardListener.cancel();
    super.dispose();
  }
}
