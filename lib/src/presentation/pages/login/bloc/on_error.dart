part of login_page;

extension on _LoginBloc {
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
      emit(
        _InitialState(
          autovalidateMode: AutovalidateMode.always,
          invalidCredentials: {
            ...state.invalidCredentials,
            Tuple2(
              emailController.text.trim(),
              passwordController.text,
            ),
          },
        ),
      );
      formKey.currentState!.validate();
    }
  }
}
