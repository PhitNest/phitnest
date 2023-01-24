import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/failures.dart';
import '../event/login_event.dart';
import '../state/confirm_user.dart';
import '../state/loading.dart';
import '../state/login_state.dart';

void onLoginError(
  LoginErrorEvent event,
  Emitter<LoginState> emit,
  LoginState state,
) {
  if (state is LoadingState) {
    if (event.failure == kUserNotConfirmed) {
      emit(ConfirmUserState(email: event.email, password: event.password));
    } else {
      emit(
        InitialState(
          autovalidateMode: AutovalidateMode.always,
          emailController: state.emailController,
          passwordController: state.passwordController,
          emailFocusNode: state.emailFocusNode,
          passwordFocusNode: state.passwordFocusNode,
          formKey: state.formKey,
          invalidCredentials: {
            ...state.invalidCredentials,
            Tuple2(
              state.emailController.text.trim(),
              state.passwordController.text,
            ),
          },
        ),
      );
      Future.delayed(const Duration(milliseconds: 50),
          () => state.formKey.currentState!.validate());
    }
  } else {
    throw Exception('Invalid state: $state');
  }
}
