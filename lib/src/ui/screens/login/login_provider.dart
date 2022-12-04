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
        scrollController: state.scrollController,
        emailController: state.emailController,
        passwordController: state.passwordController,
        onPressedSignIn: () {
          if (!state.formKey.currentState!.validate()) {
            state.validateMode = AutovalidateMode.always;
          } else {}
        },
        validateEmail: (value) => validateEmail(value),
        validatePassword: (value) => validatePassword(value),
        onTapEmail: () => state.scrollController.animateTo(
          0.2,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeIn,
        ),
        onTapPassword: () => state.scrollController.animateTo(
          0.3,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeIn,
        ),
        autovalidateMode: state.validateMode,
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
