import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import './after_forgotPassword_state.dart';
import './after_forgotPassword_view.dart';

class AfterForgotPasswordProvider
    extends ScreenProvider<AfterForgotPasswordCubit, AfterForgotPasswordState> {
  const AfterForgotPasswordProvider() : super();

  @override
  Widget builder(
    BuildContext context,
    AfterForgotPasswordCubit cubit,
    AfterForgotPasswordState state,
  ) =>
      AfterForgotPasswordView(
        onPressedSignIn: () => Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => LoginProvider(),
          ),
          (_) => false,
        ),
      );

  @override
  AfterForgotPasswordCubit buildCubit() => AfterForgotPasswordCubit();
}
