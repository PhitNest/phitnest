import 'dart:io';

import 'package:flutter/material.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:select_photo/select_photo.dart';
import 'package:validation/validation.dart';

import '../providers.dart';
import 'signup_view.dart';
import 'signup_model.dart';

class SignupProvider
    extends PreAuthenticationProvider<SignupModel, SignupView> {
  const SignupProvider({Key? key}) : super(key: key);

  @override
  init(BuildContext context, SignupModel model) async {
    if (await super.init(context, model)) {
      // Android camera data
      if (Platform.isAndroid) {
        model.image = await retrieveLostData();
      }

      return true;
    }

    return false;
  }

  @override
  SignupView buildView(BuildContext context, SignupModel model) => SignupView(
        formKey: model.formKey,
        passwordController: model.passwordController,
        validate: model.validate,
        image: model.image,
        onClickSignup: () => showProgressUntil(
            context: context,
            message: 'Creating new account, Please wait...',
            showUntil: model.signUp,
            onDone: (result) {
              if (result != null) {
                showAlertDialog(context, 'Login Failed', result);
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (_) => false);
              }
            }),
        onSaveImage: (File? image) => model.image = image,
        validateName: validateName,
        onSaveFirstName: (String? firstName) => model.firstName = firstName,
        onSaveLastName: (String? lastName) => model.lastName = lastName,
        validateEmail: validateEmail,
        onSaveEmail: (String? email) => model.email = email,
        validateMobile: validateMobile,
        onSaveMobile: (String? mobile) => model.mobile = mobile,
        validatePassword: validatePassword,
        onSavePassword: (String? password) => model.password = password,
        validateConfirmPassword: (String? confirmPassword) =>
            validateConfirmPassword(
                model.passwordController.text, confirmPassword),
        onSaveConfirmPassword: (String? confirmPassword) =>
            model.confirmPassword = confirmPassword,
        onClickMobile: () => Navigator.pushNamed(context, '/mobileAuth'),
      );
}
