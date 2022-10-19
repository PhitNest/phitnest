import 'package:flutter/material.dart';

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
        onPressedForgotPassword: () {},
        onPressedRegister: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => RegisterPageOneProvider())),
      );

  @override
  LoginState buildState() => LoginState();
}
