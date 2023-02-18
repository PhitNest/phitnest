part of verification_page;

extension _OnLoginResponse on _VerificationBloc {
  void onLoginResponse(
    _LoginResponseEvent event,
    Emitter<_IVerificationState> emit,
  ) =>
      emit(_SuccessState(response: event.response));
}
