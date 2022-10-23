import 'package:flutter/material.dart';
import 'state.dart';
import 'provider.dart';

/// Holds the UI elements of a screen. All variables should be defined in the
/// [ScreenState] class associated with the [ScreenProvider] this class corresponds to.
/// This class can accept those elements as constructor arguments when
/// instantiated in [ScreenProvider]. This class should be immutable (all variables
/// should be marked final).
///
/// When the variables in your [ScreenState] change, those changes will not be
/// reflected in this class until [ScreenState.rebuildView] is called, at which
/// time [build] will be called.
abstract class ScreenView extends StatelessWidget {
  const ScreenView() : super();

  /// This will display in the AppBar
  String? get appBarText => null;

  /// Controls whether or not to show the navbar
  bool get showNavbar => false;

  /// Controls whether this screen is scrollable.
  bool get scrollable => false;
}
