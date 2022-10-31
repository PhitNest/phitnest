import 'package:flutter/material.dart';
import 'provider.dart';
import 'view.dart';

/// This class holds the dynamic components of the [ScreenProvider]
abstract class ScreenState extends ChangeNotifier {
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

  /// Rebuilds the [ScreenView] associated with the [ScreenProvider] corresponding to
  /// this class.
  rebuildView() {
    try {
      notifyListeners();
    } catch (ignore) {}
  }
}
