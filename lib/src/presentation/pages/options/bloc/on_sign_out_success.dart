part of options_page;

extension _OnSignOutSuccess on _OptionsBloc {
  void onSignOutSuccess(
    _SignOutSuccessEvent event,
    Emitter<_IOptionsState> emit,
  ) {
    if (state is _ILoadedState) {
      final state = this.state as _ILoadedState;
      emit(_SignOutSuccessState(response: state.response));
    } else {
      throw Exception('Invalid state: $state');
    }
  }
}
