import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/forgot_password_event.dart';
import '../state/forgot_password_state.dart';

void onSuccess(
  SuccessEvent event,
  Emitter<ForgotPasswordState> emit,
  ForgotPasswordState state,
) {
  if (state is LoadingState) {
    emit(SuccessState(
      passwordController: state.passwordController,
      confirmPassController: state.confirmPassController,
      emailFocusNode: state.emailFocusNode,
      passwordFocusNode: state.passwordFocusNode,
      confirmPassFocusNode: state.confirmPassFocusNode,
      emailController: state.emailController,
      autovalidateMode: AutovalidateMode.disabled,
      formKey: state.formKey,
    ));
  } else {
    throw Exception('Invalid state: $state');
  }
}
