import 'package:flutter/material.dart';

import 'base.dart';

class ForgotPasswordLoadingPage extends ForgotPasswordBasePage {
  ForgotPasswordLoadingPage({
    required super.emailController,
    required super.passwordController,
    required super.confirmPassController,
    required super.emailFocusNode,
    required super.passwordFocusNode,
    required super.confirmPassFocusNode,
    required super.onSubmit,
  }) : super(
          child: CircularProgressIndicator(),
        );
}
