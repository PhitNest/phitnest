part of home_page;

extension _HomeOnUpdatedData on HomeBloc {
  void onDataUpdated(_HomeDataUpdatedEvent event, Emitter<IHomeState> emit) {
    if (state is HomeSocketConnectedState) {
      final state = this.state as HomeSocketConnectedState;
      emit(
        HomeSocketConnectedState(
          currentPage: state.currentPage,
          connection: state.connection,
          onDisconnect: state.onDisconnect,
          onDataUpdated: state.onDataUpdated,
        ),
      );
    } else if (state is HomeInitialState) {
      final state = this.state as HomeInitialState;
      emit(
        HomeInitialState(
          currentPage: state.currentPage,
          socketConnection: state.socketConnection,
        ),
      );
    }
  }
}
