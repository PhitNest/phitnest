import 'package:flutter/material.dart';
import '../provider.dart';
import './forgot_password_state.dart';
import './forgot_password_view.dart';

class ForgotPasswordProvider
    extends ScreenProvider<ForgotPasswordState, ForgotPasswordView> {
  @override
  ForgotPasswordView build(BuildContext context, ForgotPasswordState state) =>
      ForgotPasswordView(
        emailAddressController: state.emailAddressController,
        onPressedsubmit: () {},
      );

  @override
  ForgotPasswordState buildState() => ForgotPasswordState();
}
