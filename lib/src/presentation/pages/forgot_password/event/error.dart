import 'package:flutter/material.dart';

import '../../../../common/failure.dart';
import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordErrorEvent extends ForgotPasswordEvent {
  final Failure failure;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPassController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPassFocusNode;
  final AutovalidateMode autoValidateMode;
  final GlobalKey<FormState> formKey;

  ForgotPasswordErrorEvent({
    required this.failure,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.autoValidateMode,
    required this.confirmPassFocusNode,
    required this.passwordFocusNode,
    required this.emailFocusNode,
    required this.confirmPassController,
  }) : super();

  @override
  List<Object?> get props => [
        emailController.text,
        passwordController.text,
        confirmPassController.text,
        failure
      ];
}
