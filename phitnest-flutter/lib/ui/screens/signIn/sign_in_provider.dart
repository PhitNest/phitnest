import 'package:flutter/material.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:validation/validation.dart';

import '../../../apis/apis.dart';
import '../screens.dart';
import 'sign_in_model.dart';
import 'sign_in_view.dart';

class SignInProvider
    extends PreAuthenticationProvider<SignInModel, SignInView> {
  const SignInProvider({Key? key}) : super(key: key);

  @override
  SignInView build(BuildContext context, SignInModel model) => SignInView(
        onClickMobile: () => Navigator.pushNamed(context, '/mobileAuth'),
        formKey: model.formKey,
        validate: model.validate,
        emailController: model.emailController,
        passwordController: model.passwordController,
        validateEmail: validateEmail,
        validatePassword: validatePassword,
        onClickLogin: () => onClickLogin(context, model),
        onClickResetPassword: () =>
            Navigator.pushNamed(context, '/resetPassword'),
      );

  /// Show loading dialog widget, validate input, send request to
  /// auth service, and wait for response.
  void onClickLogin(BuildContext context, SignInModel model) =>
      showProgressUntil(
          context: context,
          message: 'Logging in, please wait...',
          showUntil: () async => await login(model),
          onDone: (result) {
            // Login failed, show error alert dialog
            if (result != null) {
              showAlertDialog(context, 'Login Failed', result);
            } else {
              // If login succeeded, pop navigation stack and navigate to home
              Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
            }
          });

  Future<String?> login(SignInModel model) async {
    // Validate form
    if (model.formKey.currentState?.validate() ?? false) {
      // Saves state to all of the text controllers
      model.formKey.currentState!.save();
      return await AuthApi.instance.login(model.emailController.text.trim(),
          model.passwordController.text.trim());
    }
    model.validate = AutovalidateMode.onUserInteraction;
    return 'Invalid input';
  }

  @override
  SignInModel createModel() => SignInModel();
}