import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constants/constants.dart';
import '../event/forgot_password_event.dart';
import '../state/forgot_password_state.dart';

void onForgotPasswordError(
  ErrorEvent event,
  Emitter<ForgotPasswordState> emit,
  ForgotPasswordState state,
) {
  if (state is LoadingState) {
    if (event.failure == Failures.userNotConfirmed.instance) {
      emit(
        ConfirmEmailState(
          autovalidateMode: state.autovalidateMode,
          confirmPassController: state.confirmPassController,
          passwordController: state.passwordController,
          emailController: state.emailController,
          emailFocusNode: state.emailFocusNode,
          passwordFocusNode: state.passwordFocusNode,
          confirmPassFocusNode: state.confirmPassFocusNode,
          formKey: state.formKey,
        ),
      );
    } else {
      emit(
        ErrorState(
          failure: event.failure,
          formKey: state.formKey,
          autovalidateMode: state.autovalidateMode,
          confirmPassFocusNode: state.confirmPassFocusNode,
          passwordFocusNode: state.passwordFocusNode,
          emailFocusNode: state.emailFocusNode,
          confirmPassController: state.confirmPassController,
          passwordController: state.passwordController,
          emailController: state.emailController,
        ),
      );
    }
  } else {
    throw Exception('Invalid state: $state');
  }
}
