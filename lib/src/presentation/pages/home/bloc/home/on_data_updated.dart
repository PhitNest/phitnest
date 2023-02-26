part of home_page;

extension _HomeOnUpdatedData on HomeBloc {
  void onDataUpdated(_HomeDataUpdatedEvent event, Emitter<IHomeState> emit) {
    if (state is _HomeSocketConnectedState) {
      final state = this.state as _HomeSocketConnectedState;
      emit(
        _HomeSocketConnectedState(
          currentPage: state.currentPage,
          connection: state.connection,
          onDisconnect: state.onDisconnect,
        ),
      );
    } else if (state is _HomeInitialState) {
      final state = this.state as _HomeInitialState;
      emit(
        _HomeInitialState(
          currentPage: state.currentPage,
          socketConnection: state.socketConnection,
        ),
      );
    }
  }
}
