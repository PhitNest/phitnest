part of home_page;

extension _OptionsOnSignOutResponse on _OptionsBloc {
  void onSignOutResponse(
    _OptionsSignOutResponseEvent event,
    Emitter<_IOptionsState> emit,
  ) =>
      emit(_OptionsSignOutState(response: state.response));
}
