import 'package:flutter/material.dart';

import '../../../common/validators.dart';
import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'login_state.dart';
import 'login_view.dart';

class LoginProvider extends ScreenProvider<LoginState, LoginView> {
  @override
  LoginView build(BuildContext context, LoginState state) => LoginView(
        emailController: state.emailController,
        passwordController: state.passwordController,
        onPressedSignIn: () => login(context, state),
        validateEmail: validateEmail,
        autovalidateMode: state.validateMode,
        validatePassword: (pass) =>
            pass?.length == 0 ? "Password is required" : null,
        formKey: state.formKey,
        onPressedForgotPassword: () => Navigator.push(
            context,
            NoAnimationMaterialPageRoute(
                builder: (context) => ForgotPasswordProvider())),
        onPressedRegister: () => Navigator.push(
            context,
            NoAnimationMaterialPageRoute(
                builder: (context) => RegisterPageOneProvider())),
      );

  login(BuildContext context, LoginState state) {
    if (!state.formKey.currentState!.validate()) {
      state.validateMode = AutovalidateMode.always;
    } else {}
  }

  @override
  LoginState buildState() => LoginState();
}
