import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import './after_forgotPassword_state.dart';
import './after_forgotPassword_view.dart';

class AfterForgotPasswordProvider
    extends ScreenProvider<AfterForgotPasswordState, AfterForgotPasswordView> {
  const AfterForgotPasswordProvider() : super();

  @override
  AfterForgotPasswordView build(
          BuildContext context, AfterForgotPasswordState state) =>
      AfterForgotPasswordView(
        onPressedSignIn: () => Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => const LoginProvider(),
          ),
          (_) => false,
        ),
      );

  @override
  AfterForgotPasswordState buildState() => AfterForgotPasswordState();
}
