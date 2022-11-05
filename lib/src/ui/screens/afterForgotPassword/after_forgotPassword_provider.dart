import 'package:flutter/material.dart';
import '../provider.dart';
import './after_forgotPassword_state.dart';
import './after_forgotPassword_view.dart';

class AfterForgotPasswordProvider
    extends ScreenProvider<AfterForgotPasswordState, AfterForgotPasswordView> {
  @override
  AfterForgotPasswordView build(
          BuildContext context, AfterForgotPasswordState state) =>
      AfterForgotPasswordView(
        onPressedSignIn: () {},
      );

  @override
  AfterForgotPasswordState buildState() => AfterForgotPasswordState();
}
