part of home_page;

extension _HomeOnSocketConnected on HomeBloc {
  void onSocketConnected(
    _HomeSocketConnectedEvent event,
    Emitter<IHomeState> emit,
  ) =>
      Repositories.directMessage.stream(connection: event.connection).fold(
            (directMessageStream) => Repositories.friendRequest
                .stream(connection: event.connection)
                .fold(
                  (friendRequestStream) => Repositories.friendship
                      .stream(connection: event.connection)
                      .fold(
                        (friendshipStream) => emit(
                          HomeSocketConnectedState(
                            currentPage: state.currentPage,
                            connection: event.connection,
                            onDisconnect: CancelableOperation.fromFuture(
                              event.connection.onDisconnect(),
                            )..then(
                                (_) =>
                                    add(const _HomeSocketConnectErrorEvent()),
                              ),
                            onDataUpdated: MergeStream([
                              directMessageStream.map((_) => null),
                              friendRequestStream.map((_) => null),
                              friendshipStream.map((_) => null),
                            ]).listen(
                              (_) => add(const _HomeDataUpdatedEvent()),
                            ),
                          ),
                        ),
                        (failure) => add(const _HomeSocketConnectErrorEvent()),
                      ),
                  (failure) => add(const _HomeSocketConnectErrorEvent()),
                ),
            (failure) => add(const _HomeSocketConnectErrorEvent()),
          );
}
