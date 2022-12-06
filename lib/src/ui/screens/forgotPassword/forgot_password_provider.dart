import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import './forgot_password_state.dart';
import './forgot_password_view.dart';

class ForgotPasswordProvider
    extends ScreenProvider<ForgotPasswordState, ForgotPasswordView> {
  const ForgotPasswordProvider() : super();

  @override
  ForgotPasswordView build(BuildContext context, ForgotPasswordState state) =>
      ForgotPasswordView(
        scrollController: state.scrollController,
        emailAddressController: state.emailAddressController,
        onPressedsubmit: () => Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => const AfterForgotPasswordProvider(),
          ),
          (_) => false,
        ),
        emailFocus: state.emailFocus,
        onTapEmail: () => Future.delayed(
          const Duration(milliseconds: 600),
          () => state.onFocusEmail(true),
        ),
      );

  @override
  ForgotPasswordState buildState() => ForgotPasswordState();
}
