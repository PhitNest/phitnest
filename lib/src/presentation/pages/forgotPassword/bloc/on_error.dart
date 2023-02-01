part of forgot_password_page;

extension on _ForgotPasswordBloc {
  void onForgotPasswordError(
    _ErrorEvent event,
    Emitter<_ForgotPasswordState> emit,
  ) {
    if (event.failure == Failures.userNotConfirmed.instance) {
      emit(
        _ConfirmingEmailState(
          autovalidateMode: state.autovalidateMode,
        ),
      );
    } else {
      emit(
        _ErrorState(
          failure: event.failure,
          autovalidateMode: state.autovalidateMode,
        ),
      );
    }
  }
}
