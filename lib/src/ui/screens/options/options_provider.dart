import 'package:flutter/material.dart';

import '../provider.dart';
import 'options_state.dart';
import 'options_view.dart';

class OptionsProvider extends ScreenProvider<OptionsState, OptionsView> {
  const OptionsProvider() : super();

  @override
  OptionsView build(BuildContext context, OptionsState state) => OptionsView();

  @override
  OptionsState buildState() => OptionsState();
}
