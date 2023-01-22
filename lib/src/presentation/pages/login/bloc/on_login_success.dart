import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/login_event.dart';
import '../state/loading.dart';
import '../state/login_state.dart';
import '../state/login_success.dart';

void onLoginSuccess(
  LoginSuccessEvent event,
  Emitter<LoginState> emit,
  LoginState state,
) {
  if (state is LoadingState) {
    emit(LoginSuccessState(response: event.response));
  } else {
    throw Exception('Invalid state: $state');
  }
}
