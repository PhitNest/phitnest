import 'package:flutter/material.dart';

import '../state.dart';

import 'apology_provider.dart';
import 'apology_view.dart';

/**
 * Holds the dynamic content of [ApologyProvider]. Calls to [rebuildView] will rebuild 
 * the [ApologyView].
 */
class ApologyState extends ScreenState {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();
  AutovalidateMode _validateMode = AutovalidateMode.disabled;

  AutovalidateMode get validateMode => _validateMode;

  set validateMode(AutovalidateMode validateMode) {
    _validateMode = validateMode;
    rebuildView();
  }
}
