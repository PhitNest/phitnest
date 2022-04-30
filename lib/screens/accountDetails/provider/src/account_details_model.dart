import 'package:flutter/material.dart';

class AccountDetailsModel extends ChangeNotifier {
  GlobalKey<FormState> key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? firstName, lastName, age, bio, school, email, mobile;

  AutovalidateMode get validate => _validate;

  set validate(AutovalidateMode validate) {
    _validate = validate;
    notifyListeners();
  }
}
