import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

import 'state.dart';
import 'view.dart';

abstract class ScreenProvider<T extends ScreenState, K extends ScreenView>
    extends StatefulWidget {
  const ScreenProvider() : super();

  T buildState();

  Future<void> init(BuildContext context, T state) async {}

  K build(BuildContext context, T state);

  Widget buildLoading(BuildContext context, T state) => Scaffold();

  Future<void> dispose(BuildContext context, T state) async {}

  @nonVirtual
  @override
  State<StatefulWidget> createState() => _WidgetProviderState();
}

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
          builder: (context, value, child) => value.initialized
              ? widget.build(context, value)
              : widget.buildLoading(context, state)));

  @override
  void dispose() {
    super.dispose();
    state.dispose();
    widget.dispose(context, state);
  }
}
