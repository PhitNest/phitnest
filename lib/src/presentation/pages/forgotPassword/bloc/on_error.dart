part of forgot_password_page;

extension _OnForgotPassword on _ForgotPasswordBloc {
  void onForgotPasswordError(
    _ErrorEvent event,
    Emitter<_IForgotPasswordState> emit,
  ) {
    if (event.failure == Failures.userNotConfirmed.instance) {
      emit(
        _ConfirmingEmailState(
          autovalidateMode: state.autovalidateMode,
        ),
      );
    } else {
      StyledErrorBanner.show(event.failure);
      emit(
        _InitialState(
          autovalidateMode: state.autovalidateMode,
        ),
      );
    }
  }
}
