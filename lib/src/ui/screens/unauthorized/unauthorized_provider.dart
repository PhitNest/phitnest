import 'package:flutter/material.dart';

import '../provider.dart';
import 'unauthorized_state.dart';
import 'unauthorized_view.dart';

class UnauthorizedProvider
    extends ScreenProvider<UnauthorizedState, UnauthorizedView> {
  @override
  UnauthorizedView build(BuildContext context, UnauthorizedState state) =>
      UnauthorizedView(
        onRegister: () {},
        onSignIn: () {},
      );

  @override
  UnauthorizedState buildState() => UnauthorizedState();
}
