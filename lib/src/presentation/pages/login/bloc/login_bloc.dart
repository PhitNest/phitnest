import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/cancel_login.dart';
import '../event/login_event.dart';
import '../event/reset.dart';
import '../state/initial/loading.dart';
import '../state/login_state.dart';
import 'on_cancel_login.dart';
import 'on_login_error.dart';
import 'on_login_success.dart';
import 'on_reset.dart';
import 'on_submit.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(
          InitialState(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            emailFocusNode: FocusNode(),
            passwordFocusNode: FocusNode(),
            formKey: GlobalKey(),
            autovalidateMode: AutovalidateMode.disabled,
            invalidCredentials: {},
          ),
        ) {
    on<SubmitEvent>((event, emit) => onSubmit(event, emit, state, add));
    on<LoginSuccessEvent>((event, emit) => onLoginSuccess(event, emit, state));
    on<LoginErrorEvent>((event, emit) => onLoginError(event, emit, state));
    on<ResetEvent>((event, emit) => onReset(event, emit, state));
    on<CancelLoginEvent>((event, emit) => onCancelLogin(event, emit, state));
  }

  @override
  Future<void> close() {
    if (state is LoadingState) {
      final loadingState = state as LoadingState;
      loadingState.loginOperation.cancel();
    }
    if (state is InitialState) {
      final initialState = state as InitialState;
      initialState.emailController.dispose();
      initialState.passwordController.dispose();
      initialState.emailFocusNode.dispose();
      initialState.passwordFocusNode.dispose();
    }
    return super.close();
  }
}
