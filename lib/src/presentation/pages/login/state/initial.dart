import 'package:flutter/material.dart';

import 'login_state.dart';

class InitialState extends LoginState {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final GlobalKey<FormState> formKey;

  const InitialState({
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.formKey,
  }) : super();
}
