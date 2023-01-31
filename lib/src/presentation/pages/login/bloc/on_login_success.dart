import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/login_event.dart';
import '../state/initial/loading.dart';
import '../state/login_state.dart';
import '../state/login_success.dart';

void onLoginSuccess(
  LoginSuccessEvent event,
  Emitter<LoginState> emit,
  LoginState state,
) {
  if (state is LoadingState) {
    emit(
      LoginSuccessState(
        response: event.response,
        password: state.passwordController.text,
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
