import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'options_state.dart';
import 'options_view.dart';

class OptionsProvider extends ScreenProvider<OptionsState, OptionsView> {
  const OptionsProvider() : super();

  @override
  OptionsView build(BuildContext context, OptionsState state) => OptionsView(
        onPressedLogo: () => Navigator.of(context).pushAndRemoveUntil(
          NoAnimationMaterialPageRoute(
            builder: (context) => const ExploreProvider(),
          ),
          (_) => false,
        ),
      );

  @override
  OptionsState buildState() => OptionsState();
}
