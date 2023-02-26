part of home_page;

extension _HomeOnSocketConnectError on HomeBloc {
  void onSocketConnectError(
    _HomeSocketConnectErrorEvent event,
    Emitter<IHomeState> emit,
  ) async {
    if (state is HomeSocketConnectedState) {
      final state = this.state as HomeSocketConnectedState;
      await state.onDisconnect.cancel();
      await state.onDataUpdated.cancel();
      state.connection.disconnect();
    }
    emit(
      HomeInitialState(
        currentPage: state.currentPage,
        socketConnection: CancelableOperation.fromFuture(
          connectSocket(Cache.auth.accessToken!),
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
