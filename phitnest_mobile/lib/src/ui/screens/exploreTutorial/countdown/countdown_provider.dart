import 'package:flutter/material.dart';
import 'package:phitnest_mobile/src/ui/screens/provider.dart';

import 'countdown_state.dart';
import 'countdown_view.dart';

class CountdownProvider extends ScreenProvider<CountdownState, CountdownView> {
  @override
  CountdownView build(BuildContext context, CountdownState state) =>
      CountdownView();

  @override
  CountdownState buildState() => CountdownState();
}
