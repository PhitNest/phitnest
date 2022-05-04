import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../../../../services/authentication_service.dart';
import '../../../../locator.dart';
import '../../base_model.dart';

class SignupModel extends BaseModel {
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  String? firstName, lastName, email, mobile, password, confirmPassword;
  File? _image;
  AutovalidateMode _validate = AutovalidateMode.disabled;

  AutovalidateMode get validate => _validate;

  set validate(AutovalidateMode validate) {
    _validate = validate;
    notifyListeners();
  }

  File? get image => _image;

  set image(File? image) {
    _image = image;
    notifyListeners();
  }

  Future<String?> signUp() async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      Position? signUpLocation = await getCurrentLocation();
      if (signUpLocation != null) {
        return await locator<AuthenticationService>()
            .signupWithEmailAndPassword(email!.trim(), password!.trim(), _image,
                firstName!, lastName!, signUpLocation, mobile!);
      } else {
        return 'Location is required to match you with people from your area';
      }
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
