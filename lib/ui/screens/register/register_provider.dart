import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_widgets/progress_widgets.dart';
import 'package:device/device.dart';
import 'package:validation/validation.dart';

import '../../../apis/api.dart';
import '../../../models/models.dart';
import '../../common/widgets/widgets.dart';
import '../screens.dart';
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
      // // Android camera data
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
        dateOfBirthController: model.dateOfBirthController,
        passwordController: model.passwordController,
        confirmPasswordController: model.confirmPasswordController,
        validate: model.validate,
        image: model.image,
        onClickSignup: () => onClickSignup(context, model),
        onSaveImage: (File? photo) => model.image = photo,
        validateFirstName: validateFirstName,
        validateLastName: validateLastName,
        validateEmail: validateEmail,
        validateMobile: validateMobile,
        validateDateOfBirth: validateDateOfBirth,
        validatePassword: validatePassword,
        validateConfirmPassword: (String? confirmPassword) =>
            validateConfirmPassword(
                model.passwordController.text, confirmPassword),
      );

  void onClickSignup(BuildContext context, RegisterModel model) =>
      showProgressUntil(
          context: context,
          message: 'Creating new account, Please wait...',
          spinner: LoadingWheel(
            color: Colors.white,
            scale: 0.25,
            padding: EdgeInsets.zero,
          ),
          showUntil: () => register(model),
          onDone: (result) {
            if (result != null) {
              showAlertDialog(context, 'Signup Failed', result);
            } else {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
            }
          });

  /// Validate the form, request the user location, and make a registration
  /// request to the authentication service. Return null if the registration
  /// is successful, and return an error message otherwise.
  Future<String?> register(RegisterModel model) async {
    if (model.formKey.currentState?.validate() ?? false) {
      model.formKey.currentState!.save();
      Position? position = await getCurrentLocation();
      return await api<AuthenticationApi>().registerWithEmailAndPassword(
          emailAddress: model.emailController.text.trim(),
          password: model.passwordController.text.trim(),
          firstName: model.firstNameController.text.trim(),
          lastName: model.lastNameController.text.trim(),
          mobile: model.mobileController.text.trim(),
          birthday: DateTime.parse(model.dateOfBirthController.text.trim()),
          ip: await userIP,
          profilePicture: model.image,
          locationData: position == null
              ? null
              : Location(
                  latitude: position.latitude, longitude: position.longitude));
    }
    model.validate = AutovalidateMode.onUserInteraction;
    return 'Invalid input';
  }

  @override
  RegisterModel createModel() => RegisterModel();
}
