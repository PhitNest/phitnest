part of forgot_password_page;

extension _OnForgotPassword on _ForgotPasswordBloc {
  void onForgotPasswordError(
    _ErrorEvent event,
    Emitter<_IForgotPasswordState> emit,
  ) =>
      emit(
        event.failure == Failures.userNotConfirmed.instance
            ? _ConfirmingEmailState(
                autovalidateMode: state.autovalidateMode,
              )
            : _ErrorState(
                autovalidateMode: state.autovalidateMode,
                errorBanner: StyledErrorBanner(
                  failure: event.failure,
                ),
              ),
      );
}
