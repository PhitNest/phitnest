part of home_page;

class AuthMethods {
  final Future<Either<T, Failure>> Function<T>(
      Future<Either<T, Failure>> Function(String) f) withAuth;
  final Future<Failure?> Function(Future<Failure?> Function(String) f)
      withAuthVoid;
  final Future<Either3<A, B, Failure>> Function<A, B>(
      Future<Either3<A, B, Failure>> Function(String) f) withAuthEither3;

  const AuthMethods({
    required this.withAuth,
    required this.withAuthVoid,
    required this.withAuthEither3,
  });
}

extension on BuildContext {
  AuthMethods get authMethods => AuthMethods(
        withAuth: <T>(
          Future<Either<T, Failure>> Function(String) f,
        ) =>
            f(Cache.auth.accessToken!).then(
          (either) => either.fold(
            (response) => Left(response),
            (failure) {
              if (failure == Failures.unauthorized.instance) {
                return Repositories.auth
                    .refreshSession(
                      email: Cache.user.user!.email,
                      refreshToken: Cache.auth.refreshToken!,
                    )
                    .then(
                      (either) => either.fold(
                        (refreshResponse) {
                          homeBloc
                              .add(_HomeRefreshSessionEvent(refreshResponse));
                          return f(refreshResponse.accessToken);
                        },
                        (failure) => Repositories.auth
                            .login(
                              email: Cache.user.user!.email,
                              password: Cache.auth.password!,
                            )
                            .then(
                              (either) => either.fold(
                                (loginResponse) => f(loginResponse.accessToken),
                                (failure) {
                                  optionsBloc.add(
                                      const _OptionsSignOutResponseEvent());
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
        ),
        withAuthVoid: (Future<Failure?> Function(String) f) => this
            .authMethods
            .withAuth(
              (accessToken) => f(accessToken).then(
                (failure) => failure != null
                    ? Right<Null, Failure>(failure)
                    : Left(null),
              ),
            )
            .then(
              (either) => either.fold(
                (success) => null,
                (failure) => failure,
              ),
            ),
        withAuthEither3:
            <A, B>(Future<Either3<A, B, Failure>> Function(String) f) => this
                .authMethods
                .withAuth(
                  (accessToken) => f(accessToken).then(
                    (either3) => either3.fold(
                      (a) => Left(Left<A, B>(a)),
                      (b) => Left(Right<A, B>(b)),
                      (failure) => Right<Either<A, B>, Failure>(failure),
                    ),
                  ),
                )
                .then(
                  (either) => either.fold(
                    (res) => res.fold(
                      (a) => First(a),
                      (b) => Second(b),
                    ),
                    (failure) => Third(failure),
                  ),
                ),
      );
}

class HomePage extends StatelessWidget {
  /// **POP RESULT: NONE**
  ///
  /// This page is the main page of the app. It contains the [ExplorePage],
  /// [_ChatPage], [_OptionsPage] and [StyledNavBar].
  ///
  /// This page requires the [Cache] to be initialized with [Cache.user.user],
  /// [Cache.auth.accessToken], [Cache.auth.refreshToken],
  /// [Cache.profilePicture.profilePictureUrl], [Cache.gym.gym] and
  /// [Cache.auth.password].
  HomePage({
    Key? key,
  })  : assert(Cache.user.user != null),
        assert(Cache.auth.accessToken != null),
        assert(Cache.auth.refreshToken != null),
        assert(Cache.profilePicture.profilePictureUrl != null),
        assert(Cache.gym.gym != null),
        assert(Cache.auth.password != null),
        super(key: key);

  LogoState logoButtonState(
      _IHomeState homeState, _IExploreState exploreState) {
    if (homeState.currentPage != NavbarPage.explore) {
      return LogoState.disabled;
    }
    if (!(exploreState is _IExploreLoadedState) ||
        exploreState is _IExploreSendingFriendRequestState) {
      return LogoState.loading;
    } else if (exploreState is _IExploreHoldingState) {
      return LogoState.holding;
    } else if (exploreState is _IExploreMatchedState) {
      return LogoState.reversed;
    } else if (Cache.user.userExploreResponse!.isEmpty) {
      return LogoState.disabled;
    } else {
      return LogoState.animated;
    }
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => _HomeBloc(),
          ),
          BlocProvider(
            create: (context) => _ExploreBloc(
              authMethods: context.authMethods,
            ),
          ),
          BlocProvider(
            create: (context) => _ChatBloc(
              authMethods: context.authMethods,
            ),
          ),
          BlocProvider(
            create: (context) => _OptionsBloc(
              authMethods: context.authMethods,
            ),
          ),
        ],
        child: BlocConsumer<_HomeBloc, _IHomeState>(
          listener: (context, state) {},
          builder: (context, state) => StyledScaffold(
            safeArea: false,
            body: SingleChildScrollView(
              child: SizedBox(
                height: 1.sh,
                child: Column(
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          switch (state.currentPage) {
                            case NavbarPage.explore:
                              return const _ExplorePage();
                            case NavbarPage.chat:
                              return const _ChatPage();
                            case NavbarPage.options:
                              return const _OptionsPage();
                            case NavbarPage.news:
                              return Container();
                          }
                        },
                      ),
                    ),
                    BlocConsumer<_ExploreBloc, _IExploreState>(
                      listener: (context, exploreState) {},
                      builder: (context, exploreState) => StyledNavBar(
                        page: state.currentPage,
                        onReleaseLogo: () {
                          if (state.currentPage == NavbarPage.explore) {
                            context.exploreBloc
                                .add(const _ExploreReleaseEvent());
                          }
                        },
                        onPressDownLogo: () {
                          if (state.currentPage == NavbarPage.explore) {
                            context.exploreBloc
                                .add(const _ExplorePressDownEvent());
                          } else {
                            context.homeBloc.add(
                                const _HomeSetPageEvent(NavbarPage.explore));
                          }
                        },
                        logoState: logoButtonState(state, exploreState),
                        onPressedNews: () => context.homeBloc
                            .add(const _HomeSetPageEvent(NavbarPage.news)),
                        onPressedExplore: () => context.homeBloc
                            .add(const _HomeSetPageEvent(NavbarPage.explore)),
                        onPressedOptions: () => context.homeBloc
                            .add(const _HomeSetPageEvent(NavbarPage.options)),
                        onPressedChat: () => context.homeBloc
                            .add(const _HomeSetPageEvent(NavbarPage.chat)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
