import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screen_model.dart';
import 'screen_view.dart';
import 'screens.dart';

/// This class provides state in the form of a base model to UI views.
abstract class ScreenProvider<T extends ScreenModel, K extends ScreenView>
    extends StatefulWidget {
  const ScreenProvider({Key? key}) : super(key: key);

  /// This is called each time the provider is built.
  T createModel();

  /// This is called in the initState method before building the view. Returns
  /// true if the screen should be displayed, or false if the screen should
  /// remain loading.
  Future<bool> init(BuildContext context, T model) async => true;

  /// This is called on disposal of the screen.
  onDispose(T model) {}

  /// This will build and return the view given the model.
  K build(BuildContext context, T model);

  /// This builder will provide a loading widget until the loading flag in
  /// the model is set to false.
  Widget buildLoading(BuildContext context, {Key? testingKey}) =>
      LoadingScreen(key: testingKey ?? Key('loading'));

  _ScreenProviderState<T, K> createState() =>
      _ScreenProviderState<T, K>(createModel());
}

class _ScreenProviderState<T extends ScreenModel, K extends ScreenView>
    extends State<ScreenProvider<T, K>> {
  /// This model holds all of the state of the view
  final T model;

  _ScreenProviderState(this.model);

  @override
  initState() {
    widget.init(context, model).then((shouldBuild) {
      if (shouldBuild) {
        model.loading = false;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<T>.value(
      value: model,
      builder: (context, child) => Consumer<T>(
          builder: (context, model, child) => model.loading
              ? widget.buildLoading(context)
              : widget.build(context, model)));

  @override
  dispose() {
    widget.onDispose(model);
    model.dispose();
    super.dispose();
  }
}
