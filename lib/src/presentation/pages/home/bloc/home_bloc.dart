part of home_page;

class _HomeBloc extends Bloc<_IHomeEvent, _IHomeState> {
  /// Control unit for the business logic of the [HomePage] widget.
  ///
  /// **STATE MACHINE:**
  ///
  /// * **[_InitialState]**
  ///   * on *[_LogOutEvent]* -> *[_LogOutState]*
  ///   * on *[_RefreshSessionEvent]* -> *[_InitialState]*
  ///   * on *[_SetPageEvent]* -> *[_InitialState]*
  ///   * on *[_SocketConnectErrorEvent]* -> *[_InitialState]*
  ///   * on *[_SocketConnectedEvent]* -> *[_SocketConnectedState]*
  ///   * on *[_SetDarkModeEvent]* -> *[_InitialState]*
  ///   * on *[_LogoPressedEvent]* -> *[_InitialState]*
  ///   * on *[_SetFreezeAnimationEvent] -> *[_InitialState]*
  ///
  /// * **[_SocketConnectedState]**
  ///   * on *[_LogOutEvent]* -> *[_LogOutState]*
  ///   * on *[_RefreshSessionEvent]* -> *[_InitialState]*
  ///   * on *[_SetPageEvent]* -> *[_SocketConnectedState]*
  ///   * on *[_SetDarkModeEvent]* -> *[_SocketConnectedState]*
  ///   * on *[_LogoPressedEvent]* -> *[_SocketConnectedState]*
  ///   * on *[_SetFreezeAnimationEvent] -> *[_SocketConnectedState]*
  _HomeBloc()
      : super(
          Function.apply(
            () {
              // ignore: close_sinks
              final controller = StreamController<PressType>();
              final broadcast = controller.stream.asBroadcastStream();
              return _InitialState(
                currentPage: NavbarPage.options,
                darkMode: false,
                logoPress: controller,
                socketConnection: CancelableOperation.fromFuture(
                  connectSocket(Cache.accessToken!),
                ),
                logoPressBroadcast: broadcast,
                logoPressListener: broadcast.listen((_) {}),
                freezeLogoAnimation: true,
              );
            },
            [],
          ),
        ) {
    on<_LogOutEvent>(onLogOut);
    on<_RefreshSessionEvent>(onRefreshSession);
    on<_SetPageEvent>(onSetPage);
    on<_SocketConnectErrorEvent>(onSocketConnectError);
    on<_SocketConnectedEvent>(onSocketConnected);
    on<_SetDarkModeEvent>(onSetDarkMode);
    on<_LogoPressedEvent>(onLogoPressed);
    on<_SetFreezeAnimationEvent>(onSetFreezeAnimation);
    if (state is _InitialState) {
      final state = this.state as _InitialState;
      state.logoPressListener.onData((data) => add(_LogoPressedEvent(data)));
      state.socketConnection.then(
        (either) => add(
          either.fold(
            (socketConnection) => _SocketConnectedEvent(socketConnection),
            (failure) => const _SocketConnectErrorEvent(),
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await state.logoPressListener.cancel();
    await state.logoPressBroadcast.drain();
    await state.logoPress.close();
    if (state is _InitialState) {
      final state = this.state as _InitialState;
      await state.socketConnection.cancel();
    }
    if (state is _SocketConnectedState) {
      final state = this.state as _SocketConnectedState;
      state.connection.disconnect();
    }
    return super.close();
  }
}

extension HomeBlocExt on BuildContext {
  _HomeBloc get homeBloc => read();

  void logOut() => homeBloc.add(const _LogOutEvent());

  void setFreezeAnimation(bool freeze) =>
      homeBloc.add(_SetFreezeAnimationEvent(freeze));
}

extension Auth on BuildContext {
  Future<Either<T, Failure>> withAuth<T>(
    Future<Either<T, Failure>> Function(String) f,
  ) =>
      f(Cache.accessToken!).then(
        (either) => either.fold(
          (response) => Left(response),
          (failure) {
            if (failure == Failures.unauthorized.instance) {
              return Repositories.auth
                  .refreshSession(
                    email: Cache.user!.email,
                    refreshToken: Cache.refreshToken!,
                  )
                  .then(
                    (either) => either.fold(
                      (refreshResponse) {
                        homeBloc.add(_RefreshSessionEvent(refreshResponse));
                        return f(refreshResponse.accessToken);
                      },
                      (failure) => Repositories.auth
                          .login(
                            email: Cache.user!.email,
                            password: Cache.password!,
                          )
                          .then(
                            (either) => either.fold(
                              (loginResponse) => f(loginResponse.accessToken),
                              (failure) {
                                homeBloc.add(const _LogOutEvent());
                                return Right(failure);
                              },
                            ),
                          ),
                    ),
                  );
            } else {
              return Right(failure);
            }
          },
        ),
      );

  Future<Failure?> withAuthVoid(Future<Failure?> Function(String) f) =>
      withAuth(
        (accessToken) => f(accessToken).then(
          (failure) =>
              failure != null ? Right<Null, Failure>(failure) : Left(null),
        ),
      ).then(
        (either) => either.fold(
          (success) => null,
          (failure) => failure,
        ),
      );

  SocketConnection get socketConnection =>
      (homeBloc.state as _SocketConnectedState).connection;

  bool get socketConnected => homeBloc.state is _SocketConnectedState;
}
