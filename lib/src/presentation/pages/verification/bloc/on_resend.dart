part of verification_page;

extension on _VerificationBloc {
  void onResend(
    _ResendEvent event,
    Emitter<_VerificationState> emit,
  ) =>
      emit(
        _ResendingState(
          operation: CancelableOperation.fromFuture(event.resend())
            ..then(
              (failure) => add(
                failure != null
                    ? _ResendErrorEvent(failure)
                    : const _ResetEvent(),
              ),
            ),
        ),
      );
}
