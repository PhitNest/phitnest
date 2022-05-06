import 'package:flutter/material.dart';

import '../../../services/services.dart';
import '../../../locator.dart';
import '../models.dart';

enum LoginMethod { email, apple }

/// This is the view model for the login view.
class LoginModel extends BaseModel {
  /// Authentication service instance
  final AuthenticationService _authService = locator<AuthenticationService>();

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

  /// Validate
  Future<String?> login(String method) async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState!.save();

      switch (method) {
        case 'apple':
          try {
            return await _authService.loginWithApple();
          } catch (e) {
            return 'Failed to login with Apple';
          }
        default:
          return await _authService.loginWithEmailAndPassword(
            email!.trim(),
            password!.trim(),
          );
      }
    } else {
      validate = AutovalidateMode.onUserInteraction;
      return 'Invalid input';
    }
  }
}
