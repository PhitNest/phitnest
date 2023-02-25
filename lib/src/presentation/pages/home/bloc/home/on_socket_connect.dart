part of home_page;

extension _HomeOnSocketConnected on HomeBloc {
  void onSocketConnected(
    _HomeSocketConnectedEvent event,
    Emitter<IHomeState> emit,
  ) =>
      emit(
        _HomeSocketConnectedState(
          currentPage: state.currentPage,
          connection: event.connection,
          onDisconnect: CancelableOperation.fromFuture(
            event.connection.onDisconnect(),
          )..then(
              (_) => add(
                const _HomeSocketConnectErrorEvent(),
              ),
            ),
        ),
      );
}
