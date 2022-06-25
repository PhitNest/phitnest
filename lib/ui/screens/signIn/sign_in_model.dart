import 'package:flutter/material.dart';

import '../base_model.dart';

/// This is the view model for the login view.
class SignInModel extends BaseModel {
  /// Form key
  final GlobalKey<FormState> formKey = GlobalKey();

  /// Controls the email field
  final emailController = TextEditingController();

  /// Controls the password field
  final passwordController = TextEditingController();

  /// Validation mode
  AutovalidateMode _validate = AutovalidateMode.disabled;

  AutovalidateMode get validate => _validate;

  /// This will rebuild the view
  set validate(AutovalidateMode validate) {
    _validate = validate;
    notifyListeners();
  }
}
