import 'package:flutter/material.dart';

import '../state.dart';

class ApologyState extends ScreenState {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  AutovalidateMode _validateMode = AutovalidateMode.disabled;

  AutovalidateMode get validateMode => _validateMode;

  set validateMode(AutovalidateMode validateMode) {
    _validateMode = validateMode;
    rebuildView();
  }
}
