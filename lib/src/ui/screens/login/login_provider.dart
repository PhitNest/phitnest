import 'package:flutter/material.dart';

import '../../common/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'login_state.dart';
import 'login_view.dart';

class LoginProvider extends ScreenProvider<LoginState, LoginView> {
  @override
  LoginView build(BuildContext context, LoginState state) => LoginView(
        emailController: state.emailController,
        passwordController: state.passwordController,
        onPressedSignIn: () {},
        keyboardVisible: state.keyboardVisible,
        onPressedForgotPassword: () => Navigator.push(
            context,
            NoAnimationMaterialPageRoute(
                builder: (context) => ForgotPasswordProvider())),
        onPressedRegister: () => Navigator.push(
            context,
            NoAnimationMaterialPageRoute(
                builder: (context) => RegisterPageOneProvider())),
      );

  @override
  LoginState buildState() => LoginState();
}
