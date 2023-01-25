import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../event/cancel.dart';
import '../event/error.dart';
import '../event/submit.dart';
import '../state/initial.dart';
import 'error.dart';
import 'on_submit.dart';

part '../event/forgot_password_event.dart';
part '../state/forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc()
      : super(
          ForgotPasswordInitialState(
            passwordController: TextEditingController(),
            confirmPassController: TextEditingController(),
            emailController: TextEditingController(),
            emailFocusNode: FocusNode(),
            passwordFocusNode: FocusNode(),
            confirmPassFocusNode: FocusNode(),
            formKey: GlobalKey<FormState>(),
            autoValidateMode: AutovalidateMode.disabled,
          ),
        ) {
    on<ForgotPasswordOnSubmitEvent>(
      (event, emit) => onSubmit(
        event,
        emit,
        state,
        add,
      ),
    );

    on<ForgotPassCancelEvent>((event, emit) => null);

    on<ForgotPasswordErrorEvent>((event, emit) => onForgotPasswordError());
  }
}
