import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/registration_event.dart';
import '../state/registration_state.dart';

void onRegisterSuccess(
  RegisterSuccessEvent event,
  Emitter<RegistrationState> emit,
  RegistrationState state,
  ValueChanged<RegistrationEvent> add,
) {
  if (state is RegisterRequestLoadingState) {
    emit(
      RegisterSuccessState(
        response: event.response,
        password: state.passwordController.text,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
