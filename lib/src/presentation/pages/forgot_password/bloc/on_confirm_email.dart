import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/confirm_email.dart';
import '../state/forgot_password_state.dart';
import '../state/initial/confirm_email.dart';

void onConfirmEmail(
  ConfirmEmailEvent event,
  Emitter<ForgotPasswordState> emit,
  ForgotPasswordState state,
) {
  if (state is ConfirmEmailState) {
    emit(
      ConfirmEmailState(
        passwordController: state.passwordController,
        confirmPassController: state.confirmPassController,
        emailFocusNode: state.emailFocusNode,
        passwordFocusNode: state.passwordFocusNode,
        confirmPassFocusNode: state.confirmPassFocusNode,
        emailController: state.emailController,
        autovalidateMode: state.autovalidateMode,
        formKey: state.formKey,
      ),
    );
  }
}
