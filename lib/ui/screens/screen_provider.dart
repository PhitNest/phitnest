import 'package:flutter/material.dart';

import '../base_provider.dart';
import '../common/widgets/widgets.dart';
import 'screen_model.dart';
import 'screen_view.dart';

abstract class ScreenProvider<T extends ScreenModel, K extends ScreenView>
    extends BaseProvider<T, K> {
  const ScreenProvider({Key? key}) : super(key: key);

  /// This builder will provide a loading widget until the loading flag in
  /// the model is set to false.
  @override
  Widget buildLoading(BuildContext context,
          {Key? testingKey, String? loadingText}) =>
      LoadingWidget(key: testingKey ?? Key("loading"), text: loadingText);

  @override
  K build(BuildContext context, T model);

  @override
  T createModel();
}
