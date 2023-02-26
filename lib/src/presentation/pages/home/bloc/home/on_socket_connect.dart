part of home_page;

extension _HomeOnSocketConnected on HomeBloc {
  void onSocketConnected(
    _HomeSocketConnectedEvent event,
    Emitter<IHomeState> emit,
  ) =>
      emit(
        _HomeSocketInitializingState(
          currentPage: state.currentPage,
          connection: event.connection,
          initializingStream: CancelableOperation.fromFuture(
            Future.wait(
              [
                Repositories.directMessage.stream(connection: event.connection),
                Repositories.friendship.stream(connection: event.connection),
                Repositories.friendRequest.stream(connection: event.connection),
              ],
            ).then(
              (streams) {
                final invalidIndex =
                    streams.indexWhere((stream) => stream.isRight());
                return invalidIndex != -1
                    ? Right(streams[invalidIndex].getOrElse(
                        () => throw Exception("This should never happen")))
                    : Left(
                        MergeStream(
                          streams.map(
                            (stream) => stream
                                .swap()
                                .getOrElse(() =>
                                    throw Exception("This should never happen"))
                                .map((_) => null),
                          ),
                        ),
                      );
              },
            ),
          )..then(
              (res) => add(
                res.fold(
                  (stream) => _HomeSocketInitializeSuccessEvent(stream),
                  (failure) => const _HomeSocketInitializeErrorEvent(),
                ),
              ),
            ),
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
