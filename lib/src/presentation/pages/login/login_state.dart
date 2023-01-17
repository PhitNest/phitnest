import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';

import '../bloc_state.dart';

abstract class LoginState extends BlocState {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final AutovalidateMode autovalidateMode;
  final GlobalKey<FormState> formKey;
  final String? error;

  const LoginState({
    required this.emailController,
    required this.passwordController,
    required this.autovalidateMode,
    required this.formKey,
    this.error,
  }) : super();

  @override
  List<Object> get props => [
        emailController,
        passwordController,
        autovalidateMode,
        formKey,
        error ?? '',
      ];

  @override
  Future<void> dispose() {
    emailController.dispose();
    passwordController.dispose();
    return super.dispose();
  }
}

class LoginInitial extends LoginState {
  const LoginInitial({
    required super.autovalidateMode,
    required super.emailController,
    required super.formKey,
    required super.passwordController,
    super.error,
  }) : super();

  LoginInitial copyWith({
    TextEditingController? emailController,
    TextEditingController? passwordController,
    AutovalidateMode? autovalidateMode,
    GlobalKey<FormState>? formKey,
    String? error,
  }) =>
      LoginInitial(
        emailController: emailController ?? this.emailController,
        passwordController: passwordController ?? this.passwordController,
        autovalidateMode: autovalidateMode ?? this.autovalidateMode,
        formKey: formKey ?? this.formKey,
        error: error ?? this.error,
      );
}

class LoginLoading extends LoginInitial {
  final CancelableOperation operation;

  const LoginLoading({
    required this.operation,
    required super.autovalidateMode,
    required super.emailController,
    required super.formKey,
    required super.passwordController,
    super.error,
  }) : super();

  LoginLoading copyWith({
    TextEditingController? emailController,
    TextEditingController? passwordController,
    AutovalidateMode? autovalidateMode,
    GlobalKey<FormState>? formKey,
    String? error,
    CancelableOperation? operation,
  }) =>
      LoginLoading(
        emailController: emailController ?? this.emailController,
        passwordController: passwordController ?? this.passwordController,
        autovalidateMode: autovalidateMode ?? this.autovalidateMode,
        formKey: formKey ?? this.formKey,
        error: error ?? this.error,
        operation: operation ?? this.operation,
      );

  @override
  Future<void> dispose() {
    operation.cancel();
    return super.dispose();
  }

  @override
  List<Object> get props => [
        ...super.props,
        operation,
      ];
}
