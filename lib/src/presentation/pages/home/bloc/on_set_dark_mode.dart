part of home_page;

extension _OnSetDarkMode on _HomeBloc {
  void onSetDarkMode(
    _SetDarkModeEvent event,
    Emitter<_IHomeState> emit,
  ) =>
      emit(state.copyWithDarkMode(event.darkMode));
}
