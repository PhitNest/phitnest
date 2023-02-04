part of verification_page;

extension on _VerificationBloc {
  void onSuccess(
    _SuccessEvent event,
    Emitter<_VerificationState> emit,
  ) =>
      emit(_SuccessState(response: event.response));
}
