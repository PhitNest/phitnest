part of verification_page;

extension _OnSuccess on _VerificationBloc {
  void onSuccess(
    _SuccessEvent event,
    Emitter<_IVerificationState> emit,
  ) =>
      emit(_SuccessState(response: event.response));
}
