part of home_page;

class HomeBloc extends Bloc<_IHomeEvent, IHomeState> {
  /// Control unit for the business logic of the [HomePage] widget.
  ///
  /// **STATE MACHINE:**
  ///
  /// * **[_HomeInitialState]**
  ///   * on *[_HomeRefreshSessionEvent]* -> *[_HomeInitialState]*
  ///   * on *[_HomeSetPageEvent]* -> *[_HomeInitialState]*
  ///   * on *[_HomeSocketConnectErrorEvent]* -> *[_HomeInitialState]*
  ///   * on *[_HomeSocketConnectedEvent]* -> *[_HomeSocketConnectedState]*
  ///
  /// * **[_HomeSocketConnectedState]**
  ///   * on *[_HomeRefreshSessionEvent]* -> *[_HomeInitialState]*
  ///   * on *[_HomeSetPageEvent]* -> *[_HomeSocketConnectedState]*
  HomeBloc()
      : super(
          Function.apply(
            () {
              return _HomeInitialState(
                currentPage: NavbarPage.options,
                socketConnection: CancelableOperation.fromFuture(
                  connectSocket(Cache.auth.accessToken!),
                ),
              );
            },
            [],
          ),
        ) {
    on<_HomeRefreshSessionEvent>(onRefreshSession);
    on<_HomeSetPageEvent>(onSetPage);
    on<_HomeSocketConnectErrorEvent>(onSocketConnectError);
    on<_HomeSocketConnectedEvent>(onSocketConnected);
    on<_HomeDataUpdatedEvent>(onDataUpdated);
    if (state is _HomeInitialState) {
      final state = this.state as _HomeInitialState;
      state.socketConnection.then(
        (either) => add(
          either.fold(
            (socketConnection) => _HomeSocketConnectedEvent(socketConnection),
            (failure) => const _HomeSocketConnectErrorEvent(),
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    if (state is _HomeInitialState) {
      final state = this.state as _HomeInitialState;
      await state.socketConnection.cancel();
    }
    if (state is _HomeSocketConnectedState) {
      final state = this.state as _HomeSocketConnectedState;
      state.connection.disconnect();
      await state.onDisconnect.cancel();
    }
    return super.close();
  }
}

extension _HomeBlocExt on BuildContext {
  HomeBloc get homeBloc => read();
}
