import 'package:flutter/material.dart';

import '../state.dart';

class RegisterPageOneState extends ScreenState {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  AutovalidateMode get autovalidateMode => _autovalidateMode;

  set autovalidateMode(AutovalidateMode autovalidateMode) {
    _autovalidateMode = autovalidateMode;
    rebuildView();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }
}
