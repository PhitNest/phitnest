import 'package:flutter/material.dart';
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

  /// This will run before [build]. [state.initialized] will be updated to true
  /// when this function returns. While this function is running, [buildLoading]
  /// will be rendered. When this function returns, [build] will be rendered.
  Future init(BuildContext context, T state) async {}

  /// This will be rendered until the [init] function returns.
  Widget buildLoading(BuildContext context, T state) => build(context, state);

  /// This is the actual UI of the screen that is shown when [init] returns.
  /// This should return a new instance of [K] and you will provide all of
  /// the dynamic content and callbacks through the const constructor here.
  K build(BuildContext context, T state);

  /// This runs when the screen is disposed of (popped from the navigator stack).
  dispose(BuildContext context, T state) {}

  @override
  State<StatefulWidget> createState() => _WidgetProviderState();
}

/// Implementation of our [ScreenProvider] class
class _WidgetProviderState<T extends ScreenState, K extends ScreenView>
    extends State<ScreenProvider<T, K>> {
  late final T state;

  @override
  initState() {
    super.initState();
    this.state = widget.buildState();
    widget.init(context, state).then((_) => state.initialized = true);
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
      value: state,
      builder: (context, _) => Consumer<T>(
          builder: (context, value, child) => state.initialized
              ? widget.build(context, value)
              : widget.buildLoading(context, value)));

  @override
  void dispose() {
    super.dispose();
    state.dispose();
    widget.dispose(context, state);
  }
}
