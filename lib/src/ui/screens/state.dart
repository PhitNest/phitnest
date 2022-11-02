import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'provider.dart';
import 'view.dart';

/// This class holds the dynamic components of the [ScreenProvider]
abstract class ScreenState extends ChangeNotifier {
  static KeyboardVisibilityController keyboardController =
      KeyboardVisibilityController();

  late final StreamSubscription<bool> _keyboardListener;

  ScreenState() : super() {
    _keyboardListener = keyboardController.onChange.listen((visible) {
      _keyboardVisible = visible;
      rebuildView();
    });
  }

  /// This is private to this file because we do not want other files to modify
  /// it directly. This field will be set to true when the [ScreenProvider.init]
  /// method has completed, and then the [ScreenView] will be rendered.
  bool _initialized = false;

  /// Whether or not [ScreenProvider.init] has completed.
  bool get initialized => _initialized;

  /// Set to true when [ScreenProvider.init] has completed. Results in a change from
  /// rendering [ScreenProvider.buildLoading] to [ScreenView].
  set initialized(bool initialized) {
    _initialized = initialized;
    rebuildView();
  }

  bool _keyboardVisible = false;

  /// Whether or not the keyboard is visible
  bool get keyboardVisible => _keyboardVisible;

  /// Rebuilds the [ScreenView] associated with the [ScreenProvider] corresponding to
  /// this class.
  rebuildView() {
    try {
      notifyListeners();
    } catch (ignore) {}
  }

  @override
  void dispose() {
    _keyboardListener.cancel();
    super.dispose();
  }
}
