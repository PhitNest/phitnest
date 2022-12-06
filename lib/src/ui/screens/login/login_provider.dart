import 'package:flutter/material.dart';

import '../../../common/validators.dart';
import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'login_state.dart';
import 'login_view.dart';

class LoginProvider extends ScreenProvider<LoginState, LoginView> {
  const LoginProvider() : super();

  @override
  LoginView build(BuildContext context, LoginState state) => LoginView(
        scrollController: state.scrollController,
        emailController: state.emailController,
        passwordController: state.passwordController,
        onPressedSignIn: () {
          if (!state.formKey.currentState!.validate()) {
            state.validateMode = AutovalidateMode.always;
          } else {}
        },
        focusEmail: state.focusEmail,
        focusPassword: state.focusPassword,
        validateEmail: (value) => validateEmail(value),
        validatePassword: (value) => validatePassword(value),
        autovalidateMode: state.validateMode,
        onTapEmail: () => Future.delayed(
          const Duration(milliseconds: 600),
          () => state.onFocusEmail(true),
        ),
        onTapPassword: () => Future.delayed(
          const Duration(milliseconds: 600),
          () => state.onFocusPassword(true),
        ),
        formKey: state.formKey,
        onPressedForgotPassword: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => ForgotPasswordProvider(),
          ),
        ),
        onPressedRegister: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => RegisterPageOneProvider(),
          ),
        ),
      );

  @override
  LoginState buildState() => LoginState();
}
