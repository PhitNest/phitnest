import 'package:flutter/cupertino.dart';

import '../state.dart';

class LoginState extends ScreenState {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
