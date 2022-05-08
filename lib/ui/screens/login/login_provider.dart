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
        validatePassword: validatePassword,
        // Show loading dialog widget, validate input, send request to
        // auth service, and wait for response.
        onClickLogin: (String method) => showProgressUntil(
            context: context,
            message: 'Logging in, please wait...',
            showUntil: () async => await login(method),
            onDone: (result) {
              // Login failed, show error alert dialog
              if (result != null) {
                showAlertDialog(context, 'Login Failed', result);
              } else {
                // If login succeeded, pop navigation stack and navigate to home
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (_) => false);
              }
            }),
        onClickResetPassword: () =>
            Navigator.pushNamed(context, '/resetPassword'),
        onClickMobile: () => Navigator.pushNamed(context, '/mobileAuth'),
      );

  Future<String?> login(String method) async {
    // Validate form
    if (model.formKey.currentState?.validate() ?? false) {
      // Saves state to all of the text controllers
      model.formKey.currentState!.save();
      // Call proper authentication service method
      switch (method) {
        case 'apple':
          try {
            // Apple login requires current location and user ip in case this is
            // the users first sign up. IP and location are always collected on
            // signup.
            return await authService.loginWithApple(
                await getCurrentLocation(), await userIP);
          } catch (e) {
            return 'Failed to login with Apple';
          }
        default:
          // Login with email/password
          return await authService.loginWithEmailAndPassword(
            model.emailController.text.trim(),
            model.passwordController.text.trim(),
          );
      }
    } else {
      model.validate = AutovalidateMode.onUserInteraction;
      return 'Invalid input';
    }
  }
}
