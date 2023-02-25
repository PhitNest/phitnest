part of home_page;

extension _OptionsOnLoaded on _OptionsBloc {
  void onLoaded(
    _OptionsLoadedUserEvent event,
    Emitter<_IOptionsState> emit,
  ) =>
      emit(const _OptionsLoadedUserState());
}
