import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'unauthorized_state.dart';
import 'unauthorized_view.dart';

class UnauthorizedProvider
    extends ScreenProvider<UnauthorizedCubit, UnauthorizedState> {
  const UnauthorizedProvider() : super();

  @override
  UnauthorizedCubit buildCubit() => UnauthorizedCubit();

  @override
  Widget builder(
    BuildContext context,
    UnauthorizedCubit cubit,
    UnauthorizedState state,
  ) =>
      UnauthorizedView(
        onPressedRegister: () => Navigator.of(context)
          ..pushAndRemoveUntil(
            NoAnimationMaterialPageRoute(
              builder: (context) => LoginProvider(),
            ),
            (_) => false,
          )
          ..push(
            NoAnimationMaterialPageRoute(
              builder: (context) => RegisterPageOneProvider(),
            ),
          ),
        onPressedLogin: () => Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => LoginProvider(),
          ),
          (_) => false,
        ),
      );
}
