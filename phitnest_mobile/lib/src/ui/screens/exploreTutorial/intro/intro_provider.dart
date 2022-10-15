import 'package:flutter/material.dart';

import '../../provider.dart';
import 'intro_state.dart';
import 'intro_view.dart';

class IntroProvider extends ScreenProvider<IntroState, IntroView> {
  @override
  IntroView build(BuildContext context, IntroState state) => IntroView();

  @override
  IntroState buildState() => IntroState();
}
