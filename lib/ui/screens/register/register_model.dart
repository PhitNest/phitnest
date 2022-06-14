import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models.dart';

/// View model for register view
class RegisterModel extends BaseModel {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  /// Form key
  final GlobalKey<FormState> formKey = GlobalKey();

  String? mobile;

  /// Local images file for profile picture
  File? _image;

  /// Validation
  AutovalidateMode _validate = AutovalidateMode.disabled;

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
}
