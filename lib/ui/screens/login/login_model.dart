import 'package:flutter/material.dart';

import '../models.dart';

enum LoginMethod { email, apple }

/// This is the view model for the login view.
class LoginModel extends BaseModel {
  /// Form key
  final GlobalKey<FormState> formKey = GlobalKey();

  /// Form fields
  String? email, password;

  /// Validation
  AutovalidateMode _validate = AutovalidateMode.disabled;

  AutovalidateMode get validate => _validate;

  set validate(AutovalidateMode validate) {
    _validate = validate;
    notifyListeners();
  }
}
