import 'package:flutter/material.dart';
import 'package:device/device.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:validation/validation.dart';

import '../providers.dart';
import 'sign_in_model.dart';
import 'sign_in_view.dart';

class SignInProvider
    extends PreAuthenticationProvider<SignInModel, SignInView> {
  const SignInProvider({Key? key}) : super(key: key);

  @override
  SignInView build(BuildContext context, SignInModel model) => SignInView(
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
            showUntil: () async => await login(model, method),
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

  Future<String?> login(SignInModel model, String method) async {
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
            return await authService.signInWithApple(
                await getCurrentLocation(), await userIP);
          } catch (e) {
            return 'Failed to login with Apple';
          }
        default:
          // Login with email/password
          return await authService.signInWithEmailAndPassword(
            model.emailController.text.trim(),
            model.passwordController.text.trim(),
            await getCurrentLocation(),
            await userIP,
          );
      }
    } else {
      model.validate = AutovalidateMode.onUserInteraction;
      return 'Invalid input';
    }
  }
}
