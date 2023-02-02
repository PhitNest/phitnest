part of forgot_password_page;

extension on _ForgotPasswordBloc {
  void onForgotPasswordError(
    _ErrorEvent event,
    Emitter<_ForgotPasswordState> emit,
  ) =>
      emit(
        event.failure == Failures.userNotConfirmed.instance
            ? _ConfirmingEmailState(
                autovalidateMode: state.autovalidateMode,
              )
            : _ErrorState(
                failure: event.failure,
                autovalidateMode: state.autovalidateMode,
              ),
      );
}
