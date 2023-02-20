part of options_page;

extension _OnSignOutResponse on _OptionsBloc {
  void onSignOutResponse(
    _SignOutResponseEvent event,
    Emitter<_IOptionsState> emit,
  ) {
    if (state is _ILoadedState) {
      emit(_SignOutState(response: state.response));
    }
  }
}
