part of home_page;

extension _HomeOnSetPage on HomeBloc {
  void onSetPage(
    _HomeSetPageEvent event,
    Emitter<IHomeState> emit,
  ) {
    if (state is _HomeInitialState) {
      final state = this.state as _HomeInitialState;
      emit(
        _HomeInitialState(
          currentPage: event.page,
          socketConnection: state.socketConnection,
        ),
      );
    } else if (state is _HomeSocketInitializedState) {
      final state = this.state as _HomeSocketInitializedState;
      emit(
        _HomeSocketInitializedState(
          currentPage: event.page,
          connection: state.connection,
          onDisconnect: state.onDisconnect,
          onDataUpdated: state.onDataUpdated,
        ),
      );
    } else if (state is _HomeSocketInitializingState) {
      final state = this.state as _HomeSocketInitializingState;
      emit(
        _HomeSocketInitializingState(
          currentPage: event.page,
          connection: state.connection,
          onDisconnect: state.onDisconnect,
          initializingStream: state.initializingStream,
        ),
      );
    }
  }
}
