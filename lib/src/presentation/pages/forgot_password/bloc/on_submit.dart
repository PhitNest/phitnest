import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/use_cases/forgot_password.dart';
import '../event/forgot_password_event.dart';
import '../state/forgot_password_state.dart';

void onSubmit(
  SubmitEvent event,
  Emitter<ForgotPasswordState> emit,
  ForgotPasswordState state,
  ValueChanged<ForgotPasswordEvent> add,
) {
  if (state is InitialState) {
    if (state.formKey.currentState!.validate()) {
      emit(
        LoadingState(
          passwordController: state.passwordController,
          confirmPassController: state.confirmPassController,
          emailFocusNode: state.emailFocusNode,
          passwordFocusNode: state.passwordFocusNode,
          confirmPassFocusNode: state.confirmPassFocusNode,
          emailController: state.emailController,
          autovalidateMode: state.autovalidateMode,
          formKey: state.formKey,
          forgotPassOperation: CancelableOperation.fromFuture(
            forgotPassword(state.emailController.text),
          )..then(
              (failure) {
                if (failure != null) {
                  add(ErrorEvent(failure));
                } else {
                  add(SuccessEvent());
                }
              },
            ),
        ),
      );
    } else {
      emit(
        InitialState(
          passwordController: state.passwordController,
          confirmPassController: state.confirmPassController,
          emailFocusNode: state.emailFocusNode,
          passwordFocusNode: state.passwordFocusNode,
          confirmPassFocusNode: state.confirmPassFocusNode,
          emailController: state.emailController,
          autovalidateMode: AutovalidateMode.always,
          formKey: state.formKey,
        ),
      );
    }
  }
}
