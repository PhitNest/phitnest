import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class SignUpModel extends ChangeNotifier {
  final ImagePicker imagePicker = ImagePicker();
  File? _image;
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();
  String? firstName, lastName, email, mobile, password, confirmPassword;
  Position? signUpLocation;
  AutovalidateMode _validate = AutovalidateMode.disabled;

  AutovalidateMode get validate => _validate;

  File? get image => _image;

  set validate(AutovalidateMode validate) {
    _validate = validate;
    notifyListeners();
  }

  set image(File? image) {
    _image = image;
    notifyListeners();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
}
