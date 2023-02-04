part of verification_page;

extension on _VerificationBloc {
  void onResendError(
    _ResendErrorEvent event,
    Emitter<_VerificationState> emit,
  ) =>
      emit(_ResendErrorState(failure: event.failure));
}
