part of home_page;

extension _HomeOnSetPage on _HomeBloc {
  void onSetPage(
    _HomeSetPageEvent event,
    Emitter<_IHomeState> emit,
  ) {
    if (state is _HomeInitialState) {
      final state = this.state as _HomeInitialState;
      emit(
        _HomeInitialState(
          currentPage: event.page,
          socketConnection: state.socketConnection,
        ),
      );
    } else if (state is _HomeSocketConnectedState) {
      final state = this.state as _HomeSocketConnectedState;
      emit(
        _HomeSocketConnectedState(
          currentPage: event.page,
          connection: state.connection,
          onDisconnect: state.onDisconnect,
        ),
      );
    }
  }
}
