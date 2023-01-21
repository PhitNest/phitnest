import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import 'login_state.dart';

class InitialState extends LoginState {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final GlobalKey<FormState> formKey;
  final AutovalidateMode autovalidateMode;
  final Set<Tuple2<String, String>> invalidCredentials;

  const InitialState({
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.formKey,
    required this.autovalidateMode,
    required this.invalidCredentials,
  }) : super();

  @override
  List<Object?> get props => [autovalidateMode, invalidCredentials];
}
