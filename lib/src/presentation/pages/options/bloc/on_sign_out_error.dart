part of options_page;

extension _OnSignOutError on _OptionsBloc {
  void onSignOutError(
    _SignOutErrorEvent event,
    Emitter<_IOptionsState> emit,
  ) {
    if (state is _ILoadedState) {
      final state = this.state as _ILoadedState;
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
