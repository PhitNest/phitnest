import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

abstract class BaseView<T extends ChangeNotifier> extends StatefulWidget {
  Widget build(BuildContext context, T model, Widget? child);
  onModelReady(T) {}
  onDispose(T) {}

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>> {
  T model = locator<T>();

  @override
  void initState() {
    widget.onModelReady(model);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
        create: (context) => model, child: Consumer<T>(builder: widget.build));
  }

  @override
  void dispose() {
    widget.onDispose(model);
    super.dispose();
  }
}
