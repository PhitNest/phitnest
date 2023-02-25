part of home_page;

extension _OptionsOnSignOutResponse on _OptionsBloc {
  void onSignOutResponse(
    _OptionsSignOutResponseEvent event,
    Emitter<_IOptionsState> emit,
  ) =>
      emit(const _OptionsSignOutState());
}
