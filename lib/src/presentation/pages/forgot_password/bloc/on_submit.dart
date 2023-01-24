import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/submit.dart';
import 'forgot_password_bloc.dart';

void onSubmit(
  ForgotPasswordOnSubmitEvent event,
  Emitter<ForgotPasswordState> emit,
  ForgotPasswordState state,
  ValueChanged<ForgotPasswordEvent> add,
) {
  // if (state is ForgotPasswordInitialState) {
  //   if (state.formKey.currentState!.validate()) {
  //     emit(
  //       ForgotPasswordLoadingState(
  //           passwordController: state.passwordController,
  //           confirmPassController: state.confirmPassController,
  //           emailFocusNode: state.emailFocusNode,
  //           passwordFocusNode: state.passwordFocusNode,
  //           confirmPassFocusNode: state.confirmPassFocusNode,
  //           emailController: state.emailController,
  //           autoValidateMode: state.autoValidateMode,
  //           formKey: state.formKey,
  //           forgotPassOperation: ),
  //     );
  //   }
  // }
}
