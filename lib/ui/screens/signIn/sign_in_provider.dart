import 'package:flutter/material.dart';
import 'package:device/device.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:validation/validation.dart';

import '../../../models/models.dart';
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
        onClickLogin: () => showProgressUntil(
            context: context,
            message: 'Logging in, please wait...',
            showUntil: () async => await login(model),
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
        // onClickMobile: () => Navigator.pushNamed(context, '/mobileAuth'),
      );

  Future<String?> login(SignInModel model) async {
    // Validate form
    if (model.formKey.currentState?.validate() ?? false) {
      // Saves state to all of the text controllers
      model.formKey.currentState!.save();
      Position? position = await getCurrentLocation();
      Location? location = position == null
          ? null
          : Location(
              latitude: position.latitude, longitude: position.longitude);
      // Login with email/password
      return await authService.signInWithEmailAndPassword(
        email: model.emailController.text.trim(),
        password: model.passwordController.text.trim(),
        locationData: location,
        ip: await userIP,
      );
    } else {
      model.validate = AutovalidateMode.onUserInteraction;
      return 'Invalid input';
    }
  }
}
