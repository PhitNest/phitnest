part of options_page;

extension on _OptionsBloc {
  void onSignOut(
    _SignOutEvent event,
    Emitter<_OptionsState> emit,
  ) =>
      emit(_SuccessState());
}
