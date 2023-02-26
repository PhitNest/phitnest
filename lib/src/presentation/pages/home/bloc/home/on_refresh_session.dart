part of home_page;

extension _HomeOnRefreshSession on HomeBloc {
  void onRefreshSession(
    _HomeRefreshSessionEvent event,
    Emitter<IHomeState> emit,
  ) async {
    if (state is HomeInitialState) {
      final state = this.state as HomeInitialState;
      await state.socketConnection.cancel();
    }
    if (state is HomeSocketConnectedState) {
      final state = this.state as HomeSocketConnectedState;
      state.connection.disconnect();
      await state.onDisconnect.cancel();
      await state.onDataUpdated.cancel();
    }
    emit(
      HomeInitialState(
        currentPage: state.currentPage,
        socketConnection: CancelableOperation.fromFuture(
          connectSocket(event.response.accessToken),
        )..then(
            (either) => add(
              either.fold(
                (socketConnection) =>
                    _HomeSocketConnectedEvent(socketConnection),
                (failure) => const _HomeSocketConnectErrorEvent(),
              ),
            ),
          ),
      ),
    );
  }
}
