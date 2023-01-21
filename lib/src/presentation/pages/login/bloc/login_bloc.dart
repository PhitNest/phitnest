import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/login_event.dart';
import '../state/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
      : super(
          InitialState(
            emailController: TextEditingController(),
            passwordController: TextEditingController(),
            emailFocusNode: FocusNode(),
            passwordFocusNode: FocusNode(),
            formKey: GlobalKey(),
          ),
        ) {}

  @override
  Future<void> close() {
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
