import 'package:display/display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../locator.dart';
import 'base_model.dart';
import 'base_view.dart';

/// This class provides state in the form of a base model to UI views.
abstract class BaseProvider<T extends BaseModel, K extends BaseView>
    extends StatefulWidget {
  const BaseProvider({Key? key}) : super(key: key);

  /// This is called in the initState method before building the view. Returns
  /// true if the screen was properly initialized.
  Future<bool> init(BuildContext context, T model) async => true;

  /// This is called on disposal of the screen. Returns true if the screen
  /// was properly disposed.
  onDispose(T model) {}

  /// This will build and return the view given the model.
  K buildView(BuildContext context, T model);

  /// This builder will provide a loading widget until the loading flag in
  /// the model is set to false.
  Widget buildLoading(BuildContext context, T model) => Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Container(
          color: primaryColor,
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation(primaryColor),
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
          ),
        ),
      ));

  @override
  _BaseProviderState<T, K> createState() => _BaseProviderState<T, K>();
}

class _BaseProviderState<T extends BaseModel, K extends BaseView>
    extends State<BaseProvider<T, K>> {
  /// Create a model using the factory provided from locator
  T model = locator<T>();

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
              ? widget.buildLoading(context, model)
              : widget.buildView(context, model)));

  @override
  dispose() {
    widget.onDispose(model);
    super.dispose();
  }
}
