import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../event/forgot_password_event.dart';
import '../state/forgot_password_state.dart';
import 'on_error.dart';
import 'on_submit.dart';
import 'on_success.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc()
      : super(
          InitialState(
            passwordController: TextEditingController(),
            confirmPassController: TextEditingController(),
            emailController: TextEditingController(),
            emailFocusNode: FocusNode(),
            passwordFocusNode: FocusNode(),
            confirmPassFocusNode: FocusNode(),
            formKey: GlobalKey(),
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ) {
    on<SubmitEvent>((event, emit) => onSubmit(event, emit, state, add));
    on<SuccessEvent>((event, emit) => onSuccess(event, emit, state));
    on<ErrorEvent>((event, emit) => onForgotPasswordError(event, emit, state));
  }

  @override
  Future<void> close() async {
    if (state is LoadingState) {
      final loadingState = state as LoadingState;
      await loadingState.forgotPassOperation.cancel();
      loadingState.emailController.dispose();
      loadingState.passwordController.dispose();
      loadingState.confirmPassController.dispose();
      loadingState.emailFocusNode.dispose();
      loadingState.passwordFocusNode.dispose();
      loadingState.confirmPassFocusNode.dispose();
    } else if (state is InitialState) {
      final initialState = state as InitialState;
      initialState.emailController.dispose();
      initialState.passwordController.dispose();
      initialState.confirmPassController.dispose();
      initialState.emailFocusNode.dispose();
      initialState.passwordFocusNode.dispose();
      initialState.confirmPassFocusNode.dispose();
    } else if (state is SuccessState) {
      final successState = state as SuccessState;
      successState.emailController.dispose();
      successState.passwordController.dispose();
      successState.confirmPassController.dispose();
      successState.emailFocusNode.dispose();
      successState.passwordFocusNode.dispose();
      successState.confirmPassFocusNode.dispose();
    } else if (state is ErrorState) {
      final errorState = state as ErrorState;
      errorState.emailController.dispose();
      errorState.passwordController.dispose();
      errorState.confirmPassController.dispose();
      errorState.emailFocusNode.dispose();
      errorState.passwordFocusNode.dispose();
      errorState.confirmPassFocusNode.dispose();
    }
    return super.close();
  }
}
