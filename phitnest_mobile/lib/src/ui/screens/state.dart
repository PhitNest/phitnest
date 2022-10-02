import 'package:flutter/material.dart';
import 'screen.dart';
import 'view.dart';

/**
 * This class holds the dynamic components of the [Screen]
 */
abstract class ScreenState extends ChangeNotifier {
  /**
   * This is private to this file because we do not want other files to modify
   * it directly. When this is false, [Screen.buildLoading] is rendered. This 
   * field will be set to true when the [Screen.init] method has completed, and 
   * then the [ScreenView] will be rendered.
   */
  bool _initialized = false;

  /**
   * Whether or not [Screen.init] has completed.
   */
  bool get initialized => _initialized;

  /**
   * Set to true when [Screen.init] has completed. Results in a change from
   * rendering [Screen.buildLoading] to [ScreenView].
   */
  set initialized(bool initialized) {
    _initialized = initialized;
    rebuildView();
  }

  /**
   * Rebuilds the [ScreenView] associated with the [Screen] corresponding to
   * this class.
   */
  rebuildView() {
    try {
      notifyListeners();
    } catch (ignore) {}
  }
}
