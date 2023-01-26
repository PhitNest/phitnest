import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/use_cases/reset_password.dart';
import '../event/error.dart';
import '../event/submit.dart';
import '../event/success.dart';
import '../state/error.dart';
import '../state/initial.dart';
import '../state/loading.dart';
import 'forgot_password_bloc.dart';

void onSubmit(
  ForgotPasswordOnSubmitEvent event,
  Emitter<ForgotPasswordState> emit,
  ForgotPasswordState state,
  ValueChanged<ForgotPasswordEvent> add,
) {
  if (state is ForgotPasswordInitialState) {
    if (state.formKey.currentState!.validate()) {
      emit(
        ForgotPasswordLoadingState(
          passwordController: state.passwordController,
          confirmPassController: state.confirmPassController,
          emailFocusNode: state.emailFocusNode,
          passwordFocusNode: state.passwordFocusNode,
          confirmPassFocusNode: state.confirmPassFocusNode,
          emailController: state.emailController,
          autoValidateMode: state.autoValidateMode,
          formKey: state.formKey,
          forgotPassOperation: CancelableOperation.fromFuture(
            resetPassword(state.emailController.text),
          )..then(
              (failure) => failure != null
                  ? add(
                      ForgotPasswordErrorEvent(
                        failure: failure,
                        passwordFocusNode: state.passwordFocusNode,
                        confirmPassFocusNode: state.confirmPassFocusNode,
                        emailFocusNode: state.emailFocusNode,
                        passwordController: state.passwordController,
                        confirmPassController: state.confirmPassController,
                        emailController: state.emailController,
                        formKey: state.formKey,
                        autoValidateMode: state.autoValidateMode,
                      ),
                    )
                  : add(ForgotPasswordSuccessEvent(
                      email: state.emailController.text,
                      password: state.passwordController.text,
                    )),
            ),
        ),
      );
    }
  } else if (state is ForgotPasswordErrorState) {
    if (state.formKey.currentState!.validate()) {
      emit(
        ForgotPasswordLoadingState(
          passwordController: state.passwordController,
          confirmPassController: state.confirmPassController,
          emailFocusNode: state.emailFocusNode,
          passwordFocusNode: state.passwordFocusNode,
          confirmPassFocusNode: state.confirmPassFocusNode,
          emailController: state.emailController,
          autoValidateMode: state.autoValidateMode,
          formKey: state.formKey,
          forgotPassOperation: CancelableOperation.fromFuture(
            resetPassword(state.emailController.text),
          )..then(
              (failure) => failure != null
                  ? add(
                      ForgotPasswordErrorEvent(
                        failure: failure,
                        passwordFocusNode: state.passwordFocusNode,
                        confirmPassFocusNode: state.confirmPassFocusNode,
                        emailFocusNode: state.emailFocusNode,
                        passwordController: state.passwordController,
                        confirmPassController: state.confirmPassController,
                        emailController: state.emailController,
                        formKey: state.formKey,
                        autoValidateMode: state.autoValidateMode,
                      ),
                    )
                  : add(ForgotPasswordSuccessEvent(
                      email: state.emailController.text,
                      password: state.passwordController.text,
                    )),
            ),
        ),
      );
    }
  }
}
