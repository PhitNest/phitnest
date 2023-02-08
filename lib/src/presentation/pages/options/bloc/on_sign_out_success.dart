part of options_page;

extension _OnSignOutSuccess on _OptionsBloc {
  void onSignOutSuccess(
    _SignOutSuccessEvent event,
    Emitter<_OptionsState> emit,
  ) {
    if (state is _LoadedState) {
      final state = this.state as _LoadedState;
      emit(_SignOutSuccessState(response: state.response));
    } else {
      throw Exception('Invalid state: $state');
    }
  }
}
