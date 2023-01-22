import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/repositories/repositories.dart';
import '../event/login_event.dart';
import '../state/loading.dart';
import '../state/login_state.dart';

void onSubmit(
  SubmitEvent event,
  Emitter<LoginState> emit,
  LoginState state,
  ValueChanged<LoginEvent> add,
) {
  if (state is InitialState) {
    if (state.formKey.currentState!.validate()) {
      emit(
        LoadingState(
          autovalidateMode: state.autovalidateMode,
          invalidCredentials: state.invalidCredentials,
          emailController: state.emailController,
          passwordController: state.passwordController,
          emailFocusNode: state.emailFocusNode,
          passwordFocusNode: state.passwordFocusNode,
          formKey: state.formKey,
          loginOperation: CancelableOperation.fromFuture(
            authRepo.login(
              state.emailController.text.trim(),
              state.passwordController.text,
            ),
          )..then(
              (res) => res.fold(
                (res) => add(LoginSuccessEvent(res)),
                (failure) => add(
                  LoginErrorEvent(
                    failure,
                    state.emailController.text.trim(),
                    state.passwordController.text,
                  ),
                ),
              ),
            ),
        ),
      );
    } else {
      emit(
        InitialState(
          emailController: state.emailController,
          passwordController: state.passwordController,
          emailFocusNode: state.emailFocusNode,
          passwordFocusNode: state.passwordFocusNode,
          formKey: state.formKey,
          autovalidateMode: AutovalidateMode.always,
          invalidCredentials: state.invalidCredentials,
        ),
      );
    }
  } else {
    throw Exception('Invalid state: $state');
  }
}
