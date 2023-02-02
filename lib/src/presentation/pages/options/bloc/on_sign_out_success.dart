part of options_page;

extension on _OptionsBloc {
  void onSignOutSuccess(
    _SignOutSuccessEvent event,
    Emitter<_OptionsState> emit,
  ) =>
      emit(const _SignOutSuccessState());
}
