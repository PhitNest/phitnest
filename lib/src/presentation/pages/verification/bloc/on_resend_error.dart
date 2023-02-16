part of verification_page;

extension _OnResendError on _VerificationBloc {
  void onResendError(
    _ResendErrorEvent event,
    Emitter<_IVerificationState> emit,
  ) =>
      emit(_ResendErrorState(failure: event.failure));
}
