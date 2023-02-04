part of options_page;

extension on _OptionsBloc {
  void onSignOutSuccess(
    _SuccessEvent event,
    Emitter<_OptionsState> emit,
  ) =>
      emit(const _SuccessState());
}
