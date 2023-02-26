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
  ///   * on *[_HomeSocketConnectedEvent]* -> *[_HomeSocketInitializedState]*
  ///
  /// * **[_HomeSocketInitializedState]**
  ///   * on *[_HomeRefreshSessionEvent]* -> *[_HomeInitialState]*
  ///   * on *[_HomeSetPageEvent]* -> *[_HomeSocketInitializedState]*
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
    on<_HomeSocketInitializeErrorEvent>(onSocketInitializeError);
    on<_HomeSocketInitializeSuccessEvent>(onSocketInitializeSuccess);
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
    if (state is _IHomeSocketConnectedState) {
      final state = this.state as _IHomeSocketConnectedState;
      await state.onDisconnect.cancel();
      state.connection.disconnect();
    }
    if (state is _HomeSocketInitializedState) {
      final state = this.state as _HomeSocketInitializedState;
      await state.onDataUpdated.cancel();
    }
    if (state is _HomeSocketInitializingState) {
      final state = this.state as _HomeSocketInitializingState;
      await state.initializingStream.cancel();
    }
    return super.close();
  }
}

extension _HomeBlocExt on BuildContext {
  HomeBloc get homeBloc => read();
}
