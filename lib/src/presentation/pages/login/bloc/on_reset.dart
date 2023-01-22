import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/reset.dart';
import '../state/confirm_user.dart';
import '../state/login_state.dart';

void onReset(
  ResetEvent event,
  Emitter<LoginState> emit,
  LoginState state,
) {
  if (state is ConfirmUserState) {
    emit(
      InitialState(
        emailController: TextEditingController(text: state.email),
        passwordController: TextEditingController(),
        emailFocusNode: FocusNode(),
        passwordFocusNode: FocusNode(),
        formKey: GlobalKey(),
        autovalidateMode: AutovalidateMode.disabled,
        invalidCredentials: {},
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
