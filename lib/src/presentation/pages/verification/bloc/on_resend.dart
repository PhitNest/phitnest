part of verification_page;

extension _OnResend on _VerificationBloc {
  void onResend(
    _ResendEvent event,
    Emitter<_IVerificationState> emit,
  ) {
    if (state is _ErrorState) {
      final state = this.state as _ErrorState;
      state.dismiss.complete();
    }
    emit(
      _ResendingState(
        resend: CancelableOperation.fromFuture(resend())
          ..then(
            (failure) => add(
              failure != null ? _ErrorEvent(failure) : const _ResetEvent(),
            ),
          ),
      ),
    );
  }
}
