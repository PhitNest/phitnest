import 'package:flutter/cupertino.dart';

import '../state.dart';

class LoginState extends ScreenState {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  AutovalidateMode _validateMode = AutovalidateMode.disabled;

  AutovalidateMode get validateMode => _validateMode;

  set validateMode(AutovalidateMode validateMode) {
    _validateMode = validateMode;
    rebuildView();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
