import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../../../services/services.dart';
import '../../../locator.dart';
import '../models.dart';

/// View model for sign up view
class SignupModel extends BaseModel {
  /// Password text controller
  final TextEditingController passwordController = TextEditingController();

  /// Form key
  final GlobalKey<FormState> formKey = GlobalKey();

  /// Form fields
  String? firstName, lastName, email, mobile, password, confirmPassword;

  /// Image file for profile picture
  File? _image;

  /// Validation
  AutovalidateMode _validate = AutovalidateMode.disabled;

  /// Initially the sign up screen will be loading until loading is set to
  /// false.
  SignupModel() : super(initiallyLoading: true);

  AutovalidateMode get validate => _validate;

  /// This will rebuild the view.
  set validate(AutovalidateMode validate) {
    _validate = validate;
    notifyListeners();
  }

  File? get image => _image;

  /// This will rebuild the view.
  set image(File? image) {
    _image = image;
    notifyListeners();
  }

  /// Validate the form, request the user location, and make a registration
  /// request to the authentication service. Return null if the registration
  /// is successful, and return an error message otherwise.
  Future<String?> signUp() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      Position? signUpLocation = await getCurrentLocation();
      return await locator<AuthenticationService>().signupWithEmailAndPassword(
          email!.trim(),
          password!.trim(),
          _image,
          firstName!,
          lastName!,
          signUpLocation,
          mobile!);
    } else {
      validate = AutovalidateMode.onUserInteraction;
      return 'Invalid input';
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
}
