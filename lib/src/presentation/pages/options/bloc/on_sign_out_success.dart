part of options_page;

extension _OnSignOutSuccess on _OptionsBloc {
  void onSignOutSuccess(
    _SuccessEvent event,
    Emitter<_OptionsState> emit,
  ) =>
      emit(const _SuccessState());
}
