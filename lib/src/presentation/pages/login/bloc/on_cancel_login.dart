import 'package:flutter_bloc/flutter_bloc.dart';

import '../event/login_event.dart';
import '../state/loading.dart';
import '../state/login_state.dart';

Future<void> onCancelLogin(
    LoginEvent event, Emitter<LoginState> emit, LoginState state) async {
  if (state is LoadingState) {
    await state.loginOperation.cancel();
    emit(
      InitialState(
        emailController: state.emailController,
        passwordController: state.passwordController,
        emailFocusNode: state.emailFocusNode,
        passwordFocusNode: state.passwordFocusNode,
        formKey: state.formKey,
        autovalidateMode: state.autovalidateMode,
        invalidCredentials: state.invalidCredentials,
      ),
    );
  } else if (state is InitialState) {
    // do nothing
  } else {
    throw Exception('Invalid state: $state');
  }
}
