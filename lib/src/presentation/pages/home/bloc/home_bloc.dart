part of home_page;

class _HomeBloc extends Bloc<_IHomeEvent, _IHomeState> {
  /// Control unit for the business logic of the [HomePage] widget.
  ///
  /// **STATE MACHINE:**
  ///
  /// * **[_InitialState]**
  _HomeBloc()
      : super(
          _InitialState(
            currentPage: NavbarPage.options,
            logoPress: StreamController(),
            socketConnection: CancelableOperation.fromFuture(
              connectSocket(Cache.accessToken!),
            ),
          ),
        ) {
    on<_LogOutEvent>(onLogOut);
    on<_RefreshSessionEvent>(onRefreshSession);
    on<_SetPageEvent>(onSetPage);
  }

  @override
  Future<void> close() async {
    await state.logoPress.close();
    if (state is _InitialState) {
      final state = this.state as _InitialState;
      await state.socketConnection.cancel();
    }
    return super.close();
  }
}

extension _Bloc on BuildContext {
  _HomeBloc get bloc => read();
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
                        bloc.add(_RefreshSessionEvent(refreshResponse));
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
                                bloc.add(const _LogOutEvent());
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
}
