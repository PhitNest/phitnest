import 'package:flutter/material.dart';

import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordInitialState extends ForgotPasswordState {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPassController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPassFocusNode;
  final AutovalidateMode autoValidateMode;
  final GlobalKey<FormState> formKey;

  ForgotPasswordInitialState({
    required this.passwordController,
    required this.confirmPassController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.confirmPassFocusNode,
    required this.emailController,
    required this.autoValidateMode,
    required this.formKey,
  });

  @override
  List<Object?> get props => [autoValidateMode];
}
