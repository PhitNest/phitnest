import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/error.dart';
import '../state/error.dart';
import 'forgot_password_bloc.dart';

void onForgotPasswordError(
  ForgotPasswordErrorEvent event,
  Emitter<ForgotPasswordState> emit,
) {
  emit(
    ForgotPasswordErrorState(
      failure: event.failure,
      formKey: event.formKey,
      autoValidateMode: event.autoValidateMode,
      confirmPassFocusNode: event.confirmPassFocusNode,
      passwordFocusNode: event.passwordFocusNode,
      emailFocusNode: event.emailFocusNode,
      confirmPassController: event.confirmPassController,
      passwordController: event.passwordController,
      emailController: event.emailController,
    ),
  );
}
