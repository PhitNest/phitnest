part of login_page;

extension _OnLogin on _LoginBloc {
  /// The [_CancelEvent] is issued when the user goes to the [ForgotPasswordPage] or the [RegistrationPage].
  Future<void> onCancel(
    _ILoginEvent event,
    Emitter<_ILoginState> emit,
  ) async {
    // Close the error banner.
    if (state is _ErrorState) {
      final state = this.state as _ErrorState;
      state.errorBanner.dismiss();
    }
    // Cancel the loading operation for sign in.
    if (state is _LoadingState) {
      final state = this.state as _LoadingState;
      await state.loginOperation.cancel();
    }
    // Transition to the initial state.
    emit(
      _InitialState(
        autovalidateMode: state.autovalidateMode,
        invalidCredentials: state.invalidCredentials,
      ),
    );
  }
}
