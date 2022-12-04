import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import './forgot_password_state.dart';
import './forgot_password_view.dart';

class ForgotPasswordProvider
    extends ScreenProvider<ForgotPasswordState, ForgotPasswordView> {
  @override
  ForgotPasswordView build(BuildContext context, ForgotPasswordState state) =>
      ForgotPasswordView(
        emailAddressController: state.emailAddressController,
        onPressedsubmit: () => Navigator.pushAndRemoveUntil(
            context,
            NoAnimationMaterialPageRoute(
              builder: (context) => AfterForgotPasswordProvider(),
            ),
            (_) => false),
      );

  @override
  ForgotPasswordState buildState() => ForgotPasswordState();
}
