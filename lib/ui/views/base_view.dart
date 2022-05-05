import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../../locator.dart';
import 'base_model.dart';

/// This class provides state in the form of a base model to UI views.
abstract class BaseView<T extends BaseModel> extends StatefulWidget {
  const BaseView({Key? key}) : super(key: key);

  /// This is called in the initState method.
  init(BuildContext context, T model) {}

  /// This is called on disposal of this widget.
  onDispose(T model) {}

  /// This builder provides the state model to a context.
  Widget build(BuildContext context, T model);

  /// This builder will provide a loading widget until the loading flag in
  /// the model is set to false.
  Widget buildLoading(BuildContext context, T model) => Scaffold(
      backgroundColor: Color(COLOR_PRIMARY),
      body: Center(
        child: Container(
          color: Color(COLOR_PRIMARY),
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation(Color(COLOR_PRIMARY)),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
          ),
        ),
      ));

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  /// Create a model using the factory provided from locator
  T model = locator<T>();

  @override
  void initState() {
    widget.init(context, model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<T>.value(
      value: model,
      child: Consumer<T>(
          builder: (context, model, child) => model.loading
              ? widget.buildLoading(context, model)
              : widget.build(context, model)));

  @override
  void dispose() {
    widget.onDispose(model);
    super.dispose();
  }
}
