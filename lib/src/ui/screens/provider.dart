import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

import 'state.dart';
import 'view.dart';

/// The base class for all screens on the app. The type parameters, [T] and [K],
/// should be of type [ScreenState] and [ScreenView] respectively. When you
/// create a new child of [ScreenProvider], you should create a new child of [ScreenState]
/// and [ScreenView] as well.
abstract class ScreenProvider<T extends ScreenState, K extends ScreenView>
    extends StatefulWidget {
  const ScreenProvider() : super();

  /// This should create and return an instance of [T]. This will be called once
  /// when the screen is first built.
  T buildState();

  /// Runs when the screen is navigated to
  init(BuildContext context, T state) async {}

  /// This is the actual UI of the screen that is shown when [init] returns.
  /// This should return a new instance of [K] and you will provide all of
  /// the dynamic content and callbacks through the const constructor here.
  K build(BuildContext context, T state);

  /// This runs when the screen is disposed of (popped from the navigator stack).
  dispose(BuildContext context, T state) {}

  @nonVirtual
  @override
  State<StatefulWidget> createState() => _WidgetProviderState();
}

/// Implementation of our [ScreenProvider] class
class _WidgetProviderState<T extends ScreenState, K extends ScreenView>
    extends State<ScreenProvider<T, K>> {
  /// This is the current state of the screen
  late final T state;

  /// Builds the state with [ScreenProvider.buildState] and calls [ScreenProvider.init]
  /// After [ScreenProvider.init] is finished, the view is built with [ScreenProvider.build]
  @override
  initState() {
    super.initState();
    this.state = widget.buildState();
    widget.init(context, state).then((_) => state.initialized = true);
  }

  /// This is called whenever [ScreenState.rebuildView] is called
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
      value: state,
      builder: (context, _) => Consumer<T>(
          builder: (context, value, child) => widget.build(context, value)));

  /// Called when we leave the screen
  @override
  void dispose() {
    super.dispose();
    state.dispose();
    widget.dispose(context, state);
  }
}
