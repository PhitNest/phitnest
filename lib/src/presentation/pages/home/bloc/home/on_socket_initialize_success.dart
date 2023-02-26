part of home_page;

extension _HomeOnSocketInitializeSuccess on HomeBloc {
  void onSocketInitializeSuccess(
    _HomeSocketInitializeSuccessEvent event,
    Emitter<IHomeState> emit,
  ) {
    if (state is _HomeSocketInitializingState) {
      final state = this.state as _HomeSocketInitializingState;
      emit(
        _HomeSocketInitializedState(
          currentPage: state.currentPage,
          connection: state.connection,
          onDisconnect: state.onDisconnect,
          onDataUpdated: event.stream
              .listen((event) => add(const _HomeDataUpdatedEvent())),
        ),
      );
    }
  }
}
