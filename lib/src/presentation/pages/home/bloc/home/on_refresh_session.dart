part of home_page;

extension _HomeOnRefreshSession on HomeBloc {
  void onRefreshSession(
    _HomeRefreshSessionEvent event,
    Emitter<IHomeState> emit,
  ) async {
    if (state is _HomeInitialState) {
      final state = this.state as _HomeInitialState;
      await state.socketConnection.cancel();
    }
    if (state is _HomeSocketConnectedState) {
      final state = this.state as _HomeSocketConnectedState;
      state.connection.disconnect();
    }
    emit(
      _HomeInitialState(
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
