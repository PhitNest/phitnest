import 'package:flutter/material.dart';

import '../base_provider.dart';
import 'screen_model.dart';
import 'screen_view.dart';
import 'screens.dart';

abstract class ScreenProvider<T extends ScreenModel, K extends ScreenView>
    extends BaseProvider<T, K> {
  const ScreenProvider({Key? key}) : super(key: key);

  /// This builder will provide a loading widget until the loading flag in
  /// the model is set to false.
  @override
  Widget buildLoading(BuildContext context, {Key? testingKey}) =>
      LoadingScreen(key: testingKey ?? Key("loading"));

  @override
  K build(BuildContext context, T model);

  @override
  T createModel();
}
