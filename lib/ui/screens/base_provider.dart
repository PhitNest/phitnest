import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/widgets/widgets.dart';
import 'base_model.dart';
import 'base_view.dart';

/// This class provides state in the form of a base model to UI views.
abstract class BaseProvider<T extends BaseModel, K extends BaseView>
    extends StatefulWidget {
  const BaseProvider({Key? key}) : super(key: key);

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
  Widget buildLoading(BuildContext context, {Key? testingKey, String? text}) =>
      LoadingWidget(key: testingKey ?? Key("loading"), text: text);

  @override
  _BaseProviderState<T, K> createState() =>
      _BaseProviderState<T, K>(createModel());
}

class _BaseProviderState<T extends BaseModel, K extends BaseView>
    extends State<BaseProvider<T, K>> {
  /// This model holds all of the state of the view
  final T model;

  _BaseProviderState(this.model);

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
    super.dispose();
  }
}
