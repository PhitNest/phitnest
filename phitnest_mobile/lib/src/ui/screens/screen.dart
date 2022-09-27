import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state.dart';
import 'view.dart';
import '../../routes.dart';

/**
 * Export every screen here to make imports shorter elsewhere please.
 */
export 'onBoarding/on_boarding.dart';
export 'requestLocation/request_location.dart';
export 'apology/apology.dart';
export 'contactUs/contact_us.dart';
export 'foundLocation/found_location.dart';
export 'thankYou/thank_you.dart';
export 'gymSearch/gym_search.dart';

/**
 * The base class for all screens on the app. The type parameters, [T] and [K],
 * should be of type [ScreenState] and [ScreenView] respectively. When you
 * create a new child of [Screen], you should create a new child of [ScreenState]
 * and [ScreenView] as well. Then you should add a route to the map in [kRouteMap].
 */
abstract class Screen<T extends ScreenState, K extends ScreenView>
    extends StatefulWidget {
  const Screen() : super();

  T buildState();

  Future init(BuildContext context, T state) async {}

  Widget buildLoading(BuildContext context, T state) => build(context, state);

  K build(BuildContext context, T state);

  dispose(BuildContext context, T state) {}

  @override
  State<StatefulWidget> createState() => _ScreenWidgetState();
}

class _ScreenWidgetState<T extends ScreenState, K extends ScreenView>
    extends State<Screen<T, K>> {
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
