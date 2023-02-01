part of login_page;

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
