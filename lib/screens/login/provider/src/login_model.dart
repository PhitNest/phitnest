import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LoginModel extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  Position? currentLocation;
  String? email, password;

  AutovalidateMode get validate => _validate;

  set validate(AutovalidateMode validate) {
    _validate = validate;
    notifyListeners();
  }
}
