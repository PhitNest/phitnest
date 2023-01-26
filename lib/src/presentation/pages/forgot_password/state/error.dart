import 'package:flutter/material.dart';

import '../../../../common/failure.dart';
import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordErrorState extends ForgotPasswordState {
  final Failure failure;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPassController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPassFocusNode;
  final AutovalidateMode autoValidateMode;
  final GlobalKey<FormState> formKey;

  ForgotPasswordErrorState({
    required this.emailController,
    required this.passwordController,
    required this.confirmPassController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.confirmPassFocusNode,
    required this.autoValidateMode,
    required this.formKey,
    required this.failure,
  }) : super();

  @override
  List<Object?> get props => [
        failure,
        emailController.text,
        passwordController.text,
        confirmPassController.text
      ];
}
