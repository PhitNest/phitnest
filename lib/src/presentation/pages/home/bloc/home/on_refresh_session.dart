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
    if (state is _IHomeSocketConnectedState) {
      final state = this.state as _HomeSocketInitializedState;
      state.connection.disconnect();
      await state.onDisconnect.cancel();
      await state.onDataUpdated.cancel();
    }
    if (state is _HomeSocketInitializingState) {
      final state = this.state as _HomeSocketInitializingState;
      await state.initializingStream.cancel();
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
