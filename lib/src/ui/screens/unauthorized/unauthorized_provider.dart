import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'unauthorized_state.dart';
import 'unauthorized_view.dart';

class UnauthorizedProvider
    extends ScreenProvider<UnauthorizedState, UnauthorizedView> {
  const UnauthorizedProvider() : super();

  @override
  UnauthorizedView build(BuildContext context, UnauthorizedState state) =>
      UnauthorizedView(
        onRegister: () => Navigator.of(context).push(
          NoAnimationMaterialPageRoute(
            builder: (context) => const RegisterPageOneProvider(),
          ),
        ),
        onSignIn: () => Navigator.of(context).pushAndRemoveUntil(
          NoAnimationMaterialPageRoute(
            builder: (context) => const LoginProvider(),
          ),
          (_) => false,
        ),
      );

  @override
  UnauthorizedState buildState() => UnauthorizedState();
}
