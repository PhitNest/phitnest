import 'package:flutter/material.dart';

import '../forgot_password_state.dart';

export 'confirm_email.dart';
export 'error.dart';
export 'loading.dart';
export 'success.dart';

class InitialState extends ForgotPasswordState {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPassController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPassFocusNode;
  final AutovalidateMode autovalidateMode;
  final GlobalKey<FormState> formKey;

  const InitialState({
    required this.passwordController,
    required this.confirmPassController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.confirmPassFocusNode,
    required this.emailController,
    required this.autovalidateMode,
    required this.formKey,
  });

  @override
  List<Object?> get props => [autovalidateMode];
}
