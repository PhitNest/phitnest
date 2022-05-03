import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import 'base_model.dart';
import '../../../locator.dart';

abstract class BaseView<T extends BaseModel> extends StatefulWidget {
  init(BuildContext context, T model) async {}
  onDispose(T model) async {}

  Widget build(BuildContext context, T model);

  Widget buildLoading(BuildContext context, T model) {
    return Scaffold(
      backgroundColor: Color(COLOR_PRIMARY),
      body: Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(Color(COLOR_PRIMARY)),
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
        ),
      ),
    );
  }

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  T model = locator<T>();

  @override
  void initState() {
    widget.init(context, model).then((_) => model.loading = false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
        value: model,
        child: Consumer<T>(builder: (context, model, child) {
          return model.loading
              ? widget.buildLoading(context, model)
              : widget.build(context, model);
        }));
  }

  @override
  void dispose() async {
    await widget.onDispose(model);
    super.dispose();
  }
}
