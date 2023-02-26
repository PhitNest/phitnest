part of home_page;

class HomeBloc extends Bloc<_IHomeEvent, IHomeState> {
  /// Control unit for the business logic of the [HomePage] widget.
  ///
  /// **STATE MACHINE:**
  ///
  /// * **[HomeInitialState]**
  ///   * on *[_HomeRefreshSessionEvent]* -> *[HomeInitialState]*
  ///   * on *[_HomeSetPageEvent]* -> *[HomeInitialState]*
  ///   * on *[_HomeSocketConnectErrorEvent]* -> *[HomeInitialState]*
  ///   * on *[_HomeSocketConnectedEvent]* -> *[HomeSocketConnectedState]*
  ///
  /// * **[HomeSocketConnectedState]**
  ///   * on *[_HomeRefreshSessionEvent]* -> *[HomeInitialState]*
  ///   * on *[_HomeSetPageEvent]* -> *[HomeSocketConnectedState]*
  HomeBloc()
      : super(
          Function.apply(
            () {
              return HomeInitialState(
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
    if (state is HomeInitialState) {
      final state = this.state as HomeInitialState;
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
    if (state is HomeInitialState) {
      final state = this.state as HomeInitialState;
      await state.socketConnection.cancel();
    }
    if (state is HomeSocketConnectedState) {
      final state = this.state as HomeSocketConnectedState;
      await state.onDisconnect.cancel();
      await state.onDataUpdated.cancel();
      state.connection.disconnect();
    }
    return super.close();
  }
}

extension _HomeBlocExt on BuildContext {
  HomeBloc get homeBloc => read();
}
