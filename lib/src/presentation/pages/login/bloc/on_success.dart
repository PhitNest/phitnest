part of login_page;

extension _OnSuccess on _LoginBloc {
  /// Handles the [_SuccessEvent] event.
  void onSuccess(
    _SuccessEvent event,
    Emitter<_ILoginState> emit,
  ) =>
      // Transition to the success state.
      emit(
        _SuccessState(
          response: event.response,
          autovalidateMode: state.autovalidateMode,
          invalidCredentials: state.invalidCredentials,
        ),
      );
}
