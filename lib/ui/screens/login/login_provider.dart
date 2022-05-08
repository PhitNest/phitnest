import 'package:flutter/material.dart';
import 'package:ip/ip.dart';
import 'package:location/location.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:validation/validation.dart';

import '../providers.dart';
import 'login_model.dart';
import 'login_view.dart';

class LoginProvider extends PreAuthenticationProvider<LoginModel, LoginView> {
  LoginProvider({Key? key}) : super(key: key);

  @override
  LoginView build(BuildContext context) => LoginView(
        formKey: model.formKey,
        validate: model.validate,
        emailController: model.emailController,
        passwordController: model.passwordController,
        validateEmail: validateEmail,
        onSaveEmail: (String? email) => model.email = email,
        validatePassword: validatePassword,
        onSavePassword: (String? password) => model.password = password,
        onClickLogin: (String method) => showProgressUntil(
            context: context,
            message: 'Logging in, please wait...',
            showUntil: () async => await login(method),
            onDone: (result) {
              if (result != null) {
                showAlertDialog(context, 'Login Failed', result);
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (_) => false);
              }
            }),
        onClickResetPassword: () =>
            Navigator.pushNamed(context, '/resetPassword'),
        onClickMobile: () => Navigator.pushNamed(context, '/mobileAuth'),
      );

  /// Validate
  Future<String?> login(String method) async {
    if (model.formKey.currentState?.validate() ?? false) {
      model.formKey.currentState!.save();
      switch (method) {
        case 'apple':
          try {
            return await authService.loginWithApple(
                await getCurrentLocation(), await userIP);
          } catch (e) {
            return 'Failed to login with Apple';
          }
        default:
          return await authService.loginWithEmailAndPassword(
            model.email!.trim(),
            model.password!.trim(),
          );
      }
    } else {
      model.validate = AutovalidateMode.onUserInteraction;
      return 'Invalid input';
    }
  }
}
