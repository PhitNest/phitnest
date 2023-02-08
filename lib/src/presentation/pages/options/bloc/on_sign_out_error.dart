part of options_page;

extension _OnSignOutError on _OptionsBloc {
  void onSignOutError(
    _SignOutErrorEvent event,
    Emitter<_OptionsState> emit,
  ) {
    if (state is _LoadedState) {
      final state = this.state as _LoadedState;
      emit(
        _SignOutErrorState(
          response: state.response,
          failure: event.failure,
        ),
      );
    } else {
      throw Exception('Invalid state: $state');
    }
  }
}
