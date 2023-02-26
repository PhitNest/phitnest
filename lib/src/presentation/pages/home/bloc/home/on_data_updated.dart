part of home_page;

extension _HomeOnUpdatedData on HomeBloc {
  void onDataUpdated(_HomeDataUpdatedEvent event, Emitter<IHomeState> emit) {
    if (state is _HomeSocketInitializedState) {
      final state = this.state as _HomeSocketInitializedState;
      emit(
        _HomeSocketInitializedState(
          currentPage: state.currentPage,
          connection: state.connection,
          onDisconnect: state.onDisconnect,
          onDataUpdated: state.onDataUpdated,
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
    } else if (state is _HomeSocketInitializingState) {
      final state = this.state as _HomeSocketInitializingState;
      emit(
        _HomeSocketInitializingState(
          currentPage: state.currentPage,
          connection: state.connection,
          onDisconnect: state.onDisconnect,
          initializingStream: state.initializingStream,
        ),
      );
    }
  }
}
