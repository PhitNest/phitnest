import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:device/device.dart';
import 'package:validation/validation.dart';

import '../../../models/models.dart';
import '../providers.dart';
import 'register_view.dart';
import 'register_model.dart';

class RegisterProvider
    extends PreAuthenticationProvider<RegisterModel, RegisterView> {
  const RegisterProvider({Key? key}) : super(key: key);

  /// If this returns true, the loading widget is dropped. If it returns false,
  /// the loading widget stays until we navigate away from the screen.
  @override
  init(BuildContext context, RegisterModel model) async {
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
  RegisterView build(BuildContext context, RegisterModel model) => RegisterView(
        formKey: model.formKey,
        firstNameController: model.firstNameController,
        lastNameController: model.lastNameController,
        emailController: model.emailController,
        mobileController: model.mobileController,
        passwordController: model.passwordController,
        validate: model.validate,
        image: model.image,
        onClickSignup: () => showProgressUntil(
            context: context,
            message: 'Creating new account, Please wait...',
            showUntil: () => register(model),
            onDone: (result) {
              if (result != null) {
                showAlertDialog(context, 'Signup Failed', result);
              } else {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/home', (_) => false);
              }
            }),
        onSaveImage: (File? image) => model.image = image,
        validateFirstName: validateName,
        validateLastName: (String? lastName) =>
            lastName == '' ? null : validateName(lastName),
        validateEmail: validateEmail,
        validateMobile: validateMobile,
        onSaveMobile: (String? mobile) => model.mobile = mobile,
        validatePassword: validatePassword,
        validateConfirmPassword: (String? confirmPassword) =>
            validateConfirmPassword(
                model.passwordController.text, confirmPassword),
      );

  /// Validate the form, request the user location, and make a registration
  /// request to the authentication service. Return null if the registration
  /// is successful, and return an error message otherwise.
  Future<String?> register(RegisterModel model) async {
    if (model.formKey.currentState?.validate() ?? false) {
      model.formKey.currentState!.save();
      Position? position = await getCurrentLocation();
      Location? location = position == null
          ? null
          : Location(
              latitude: position.latitude, longitude: position.longitude);
      return await authService.registerWithEmailAndPassword(
          emailAddress: model.emailController.text.trim(),
          password: model.passwordController.text.trim(),
          firstName: model.firstNameController.text.trim(),
          lastName: model.lastNameController.text.trim(),
          mobile: model.mobile ?? '',
          ip: await userIP,
          profilePicture: model.image,
          locationData: location);
    } else {
      model.validate = AutovalidateMode.onUserInteraction;
      return 'Invalid input';
    }
  }
}
