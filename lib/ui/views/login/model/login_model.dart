import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

import '../../../../services/authentication_service.dart';
import '../../../../locator.dart';
import '../../base_model.dart';

enum LoginMethod { email, apple }

class LoginModel extends BaseModel {
  final GlobalKey<FormState> formKey = GlobalKey();
  String? email, password;

  AutovalidateMode _validate = AutovalidateMode.disabled;
  AutovalidateMode get validate => _validate;

  AuthenticationService _auth = locator<AuthenticationService>();

  LoginModel() : super(initiallyLoading: true);

  set validate(AutovalidateMode validate) {
    _validate = validate;
    notifyListeners();
  }

  Future<String?> login(LoginMethod method) async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();
      Position? currentLocation = await getCurrentLocation();
      if (currentLocation != null) {
        switch (method) {
          case LoginMethod.email:
            return await _auth.loginWithEmailAndPassword(
                email!.trim(), password!.trim(), currentLocation);
          case LoginMethod.apple:
            try {
              return await _auth.loginWithApple(currentLocation);
            } catch (e) {
              return 'Failed to login with Apple';
            }
        }
      } else {
        return 'Location is required to match you with people from your area.';
      }
    } else {
      validate = AutovalidateMode.onUserInteraction;
      return 'Invalid input';
    }
  }
}
