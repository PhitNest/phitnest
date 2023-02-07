part of verification_page;

extension _OnReset on _VerificationBloc {
  void onReset(
    _ResetEvent event,
    Emitter<_VerificationState> emit,
  ) =>
      emit(const _InitialState());
}
