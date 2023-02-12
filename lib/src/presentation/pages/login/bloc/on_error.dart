part of login_page;

extension _OnLoginError on _LoginBloc {
  void onLoginError(
    _ErrorEvent event,
    Emitter<_LoginState> emit,
  ) {
    if (event.failure == Failures.userNotConfirmed.instance) {
      emit(
        _ConfirmingEmailState(
          autovalidateMode: state.autovalidateMode,
          invalidCredentials: state.invalidCredentials,
          email: emailController.text.trim(),
          password: passwordController.text,
        ),
      );
    } else {
      Set<Tuple2<String, String>> invalidCredentials = {
        ...state.invalidCredentials,
        Tuple2(
          emailController.text.trim(),
          passwordController.text,
        ),
      };
      emit(
        _InitialState(
          autovalidateMode: AutovalidateMode.always,
          invalidCredentials: Failures.invalidPassword.instance == event.failure
              ? invalidCredentials
              : state.invalidCredentials,
        ),
      );
      formKey.currentState!.validate();
    }
  }
}
