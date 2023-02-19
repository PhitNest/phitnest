part of login_page;

extension _OnLoginError on _LoginBloc {
  /// The [_ErrorEvent] is emitted when the login request responds with a [Failure].
  void onLoginError(
    _ErrorEvent event,
    Emitter<_ILoginState> emit,
  ) {
    // If the user is not confirmed, transition to the confirming email state.
    if (event.failure == Failures.userNotConfirmed.instance) {
      emit(
        _ConfirmingEmailState(
          autovalidateMode: state.autovalidateMode,
          invalidCredentials: state.invalidCredentials,
          email: emailController.text.trim(),
          password: passwordController.text,
        ),
      );
    }
    // If the password was invalid, transition to the initial state and add the credentials
    // to invalidCredentials.
    else if (event.failure == Failures.invalidPassword.instance) {
      emit(
        _InitialState(
            autovalidateMode: AutovalidateMode.always,
            invalidCredentials: {
              ...state.invalidCredentials,
              Tuple2(
                emailController.text.trim(),
                passwordController.text,
              ),
            }),
      );
      // Call validate on the formkey so it recognizes the invalid credentials and shows an error.
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => formKey.currentState!.validate(),
      );
    } else {
      // Transition to error state
      emit(
        _ErrorState(
          autovalidateMode: AutovalidateMode.always,
          invalidCredentials: state.invalidCredentials,
          errorBanner: StyledErrorBanner(
            failure: event.failure,
          ),
        ),
      );
    }
  }
}
