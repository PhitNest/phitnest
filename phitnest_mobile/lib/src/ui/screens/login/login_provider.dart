import 'package:flutter/material.dart';
import 'package:phitnest_mobile/src/ui/screens/login/login_state.dart';
import 'package:phitnest_mobile/src/ui/screens/login/login_view.dart';

import '../provider.dart';

class LoginProvider extends ScreenProvider<LoginState, LoginView> {
  @override
  LoginView build(BuildContext context, LoginState state) => LoginView(
        emailController: state.emailController,
        passwordController: state.passwordController,
        onSignIn: () {},
        onForgotPassword: () {},
        onRegister: () {},
      );

  @override
  LoginState buildState() => LoginState();
}
