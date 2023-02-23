part of home_page;

extension on BuildContext {
  Future<Either<T, Failure>> withAuth<T>(
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
                        homeBloc.add(_HomeRefreshSessionEvent(refreshResponse));
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
                                homeBloc.add(const _HomeSignOutEvent());
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

class HomePage extends StatelessWidget {
  /// **POP RESULT: NONE**
  ///
  /// This page is the main page of the app. It contains the [ExplorePage],
  /// [ChatPage], [OptionsPage] and [StyledNavBar].
  ///
  /// This page requires the [Cache] to be initialized with [Cache.user],
  /// [Cache.accessToken], [Cache.refreshToken], [Cache.profilePictureUrl],
  /// [Cache.gym] and [Cache.password].
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
    if (!(exploreState is _IExploreLoadedState)) {
      return LogoState.loading;
    } else if (exploreState is _IExploreHoldingState) {
      return LogoState.holding;
    } else if (exploreState is _ExploreMatchedState) {
      return LogoState.reversed;
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
              withAuth: context.withAuth,
              withAuthVoid: context.withAuthVoid,
            ),
          ),
          BlocProvider(
            create: (context) => _ChatBloc(
              withAuth: context.withAuth,
              withAuthVoid: context.withAuthVoid,
            ),
          ),
          BlocProvider(
            create: (context) => _OptionsBloc(
              withAuth: context.withAuth,
              withAuthVoid: context.withAuthVoid,
            ),
          ),
        ],
        child: BlocConsumer<_HomeBloc, _IHomeState>(
          listener: (context, state) {},
          builder: (context, state) => StyledScaffold(
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
