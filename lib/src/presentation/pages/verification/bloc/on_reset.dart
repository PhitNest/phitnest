part of verification_page;

extension on _VerificationBloc {
  void onReset(
    _ResetEvent event,
    Emitter<_VerificationState> emit,
  ) =>
      emit(const _InitialState());
}
