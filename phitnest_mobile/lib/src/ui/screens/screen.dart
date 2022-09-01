import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state.dart';
import 'view.dart';

export 'onBoarding/on_boarding.dart';
export 'requestLocation/request_location.dart';
export 'apology/apology.dart';

abstract class Screen<T extends ScreenState, K extends ScreenView>
    extends StatefulWidget {
  const Screen() : super();

  T buildState();

  Future<void> init(BuildContext context, T state) async {}

  Widget buildLoading(BuildContext context, T state) => build(context, state);

  K build(BuildContext context, T state);

  dispose(BuildContext context, T state) {}

  @override
  State<StatefulWidget> createState() => _ScreenWidgetState(buildState());
}

class _ScreenWidgetState<T extends ScreenState, K extends ScreenView>
    extends State<Screen<T, K>> {
  final T state;

  _ScreenWidgetState(this.state);

  @override
  initState() {
    super.initState();
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
