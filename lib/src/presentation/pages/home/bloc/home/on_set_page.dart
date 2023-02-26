part of home_page;

extension _HomeOnSetPage on HomeBloc {
  void onSetPage(
    _HomeSetPageEvent event,
    Emitter<IHomeState> emit,
  ) {
    if (state is HomeInitialState) {
      final state = this.state as HomeInitialState;
      emit(
        HomeInitialState(
          currentPage: event.page,
          socketConnection: state.socketConnection,
        ),
      );
    } else if (state is HomeSocketConnectedState) {
      final state = this.state as HomeSocketConnectedState;
      emit(
        HomeSocketConnectedState(
          currentPage: event.page,
          connection: state.connection,
          onDisconnect: state.onDisconnect,
          onDataUpdated: state.onDataUpdated,
        ),
      );
    }
  }
}
