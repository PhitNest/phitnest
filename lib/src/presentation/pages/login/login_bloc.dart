import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../../../domain/repositories/repositories.dart';
import '../bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends PageBloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(
          LoginInitial(
            emailFocusNode: FocusNode(),
            passwordFocusNode: FocusNode(),
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            autovalidateMode: AutovalidateMode.disabled,
            formKey: GlobalKey(),
          ),
        ) {
    on<LoginError>(
      (event, emit) {
        emit(
          LoginInitial(
            emailFocusNode: state.emailFocusNode,
            passwordFocusNode: state.passwordFocusNode,
            autovalidateMode: AutovalidateMode.always,
            emailController: state.emailController,
            formKey: state.formKey,
            passwordController: state.passwordController,
            error: event.message,
          ),
        );
      },
    );
    on<SubmitEvent>(
      (event, emit) {
        final initialState = state as LoginInitial;
        if (state.formKey.currentState!.validate()) {
          state.emailFocusNode.unfocus();
          state.passwordFocusNode.unfocus();
          emit(
            LoginLoading(
              emailFocusNode: state.emailFocusNode,
              passwordFocusNode: state.passwordFocusNode,
              autovalidateMode: AutovalidateMode.disabled,
              emailController: state.emailController,
              passwordController: state.passwordController,
              formKey: state.formKey,
              operation: CancelableOperation.fromFuture(
                authRepository.login(
                  state.emailController.text.trim(),
                  state.passwordController.text,
                ),
              ).then(
                (res) => res.fold(
                  (res) {},
                  (failure) => add(LoginError(message: failure.message)),
                ),
              ),
            ),
          );
        } else {
          emit(
            initialState.copyWith(
              autovalidateMode: AutovalidateMode.always,
            ),
          );
        }
      },
    );
    on<CancelLoading>(
      (event, emit) async {
        final loadingState = state as LoginLoading;
        await loadingState.operation.cancel();
        emit(
          LoginInitial(
            emailFocusNode: loadingState.emailFocusNode,
            passwordFocusNode: loadingState.passwordFocusNode,
            autovalidateMode: AutovalidateMode.disabled,
            emailController: loadingState.emailController,
            passwordController: loadingState.passwordController,
            formKey: loadingState.formKey,
          ),
        );
      },
    );
    on<OnTypeEvent>(
      (event, emit) {
        emit(
          (state as LoginInitial).copyWith(
            error: null,
          ),
        );
      },
    );
  }

  void submit() => add(const SubmitEvent());

  void cancelLoading() => add(const CancelLoading());

  void textEdited() => add(const OnTypeEvent());
}
