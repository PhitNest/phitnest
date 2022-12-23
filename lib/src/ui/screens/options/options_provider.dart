import 'package:flutter/material.dart';

import '../screen_provider.dart';
import 'options_state.dart';
import 'options_view.dart';

class OptionsProvider extends ScreenProvider<OptionsCubit, OptionsState> {
  OptionsProvider() : super();

  @override
  Widget builder(
    BuildContext context,
    OptionsCubit cubit,
    OptionsState state,
  ) =>
      OptionsView();

  @override
  OptionsCubit buildCubit() => OptionsCubit();
}
