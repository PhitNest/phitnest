part of home_page;

extension _HomeOnSocketInitializeError on HomeBloc {
  void onSocketInitializeError(
    _HomeSocketInitializeErrorEvent event,
    Emitter<IHomeState> emit,
  ) async {
    final state = this.state as _HomeSocketInitializingState;
    await state.onDisconnect.cancel();
    state.connection.disconnect();
    emit(
      _HomeInitialState(
        currentPage: state.currentPage,
        socketConnection: CancelableOperation.fromFuture(
          connectSocket(Cache.auth.accessToken!),
        )..then(
            (res) => add(
              res.fold(
                (connection) => _HomeSocketConnectedEvent(connection),
                (failure) => const _HomeSocketConnectErrorEvent(),
              ),
            ),
          ),
      ),
    );
  }
}
