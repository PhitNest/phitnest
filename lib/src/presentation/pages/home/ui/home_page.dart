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

extension HomeAuthMethods on BuildContext {
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
  /// This page requires the [Cache] to be initialized with [Cache.user.userResponse],
  /// [Cache.auth.accessToken], [Cache.auth.refreshToken], [Cache.auth.password].
  HomePage({
    Key? key,
  })  : assert(Cache.auth.accessToken != null),
        assert(Cache.auth.refreshToken != null),
        assert(Cache.auth.password != null),
        assert(Cache.user.userResponse != null),
        super(key: key);

  LogoState logoButtonState(IHomeState homeState, _IExploreState exploreState) {
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
            create: (context) => HomeBloc(),
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
        child: BlocConsumer<HomeBloc, IHomeState>(
          buildWhen: true.always,
          listenWhen: true.always,
          listener: (context, homeState) {},
          builder: (context, homeState) =>
              BlocConsumer<_ExploreBloc, _IExploreState>(
            buildWhen: true.always,
            listenWhen: true.always,
            listener: (context, exploreState) {
              if (exploreState is _IExploreMatchedState) {
                context.homeBloc.add(const _HomeDataUpdatedEvent());
              }
            },
            builder: (context, exploreState) =>
                BlocConsumer<_ChatBloc, _IChatState>(
              buildWhen: true.always,
              listenWhen: true.always,
              listener: (context, chatState) {},
              builder: (context, chatState) =>
                  BlocConsumer<_OptionsBloc, _IOptionsState>(
                buildWhen: true.always,
                listenWhen: true.always,
                listener: (context, optionsState) async {
                  if (optionsState is _OptionsEditProfilePictureState) {
                    XFile? result;
                    await context.authMethods.withAuthVoid(
                      (accessToken) => Navigator.of(context)
                          .push<XFile>(
                        CupertinoPageRoute(
                          builder: (context) => ProfilePicturePage(
                            uploadImage: (image) =>
                                UseCases.uploadPhotoAuthorized(
                              accessToken: accessToken,
                              photo: image,
                            ),
                          ),
                        ),
                      )
                          .then(
                        (photo) {
                          if (photo != null) {
                            result = photo;
                            return null;
                          }
                          return null;
                        },
                      ),
                    );
                    if (result != null) {
                      context.optionsBloc.add(const _OptionsReloadEvent());
                    } else {
                      context.optionsBloc.add(const _OptionsLoadedUserEvent());
                    }
                  }
                  if (optionsState is _OptionsSignOutState) {
                    Navigator.of(context).pushAndRemoveUntil(
                      CupertinoPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                      (_) => false,
                    );
                  }
                },
                builder: (context, optionsState) => StyledScaffold(
                  safeArea: false,
                  lightMode: exploreState is _IExploreMatchedState,
                  body: optionsState is _OptionsSignOutState
                      ? Container(
                          child:
                              Center(child: const CircularProgressIndicator()))
                      : SingleChildScrollView(
                          child: SizedBox(
                            height: 1.sh,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Builder(
                                    builder: (context) {
                                      switch (homeState.currentPage) {
                                        case NavbarPage.explore:
                                          return _ExplorePage(
                                              state: exploreState);
                                        case NavbarPage.chat:
                                          return _ChatPage(state: chatState);
                                        case NavbarPage.options:
                                          return _OptionsPage(
                                              state: optionsState);
                                        case NavbarPage.news:
                                          return Container();
                                      }
                                    },
                                  ),
                                ),
                                StyledNavBar(
                                  friendRequestCount: Cache
                                          .friendship
                                          .friendsAndRequests
                                          ?.requests
                                          .length ??
                                      0,
                                  page: homeState.currentPage,
                                  onReleaseLogo: () {
                                    if (homeState.currentPage ==
                                        NavbarPage.explore) {
                                      context.exploreBloc
                                          .add(const _ExploreReleaseEvent());
                                    }
                                  },
                                  onPressDownLogo: () {
                                    if (homeState.currentPage ==
                                        NavbarPage.explore) {
                                      context.exploreBloc
                                          .add(const _ExplorePressDownEvent());
                                    } else {
                                      if (exploreState
                                          is _IExploreMatchedState) {
                                        context.exploreBloc
                                            .add(const _ExploreResetEvent());
                                      }
                                      context.homeBloc.add(
                                          const _HomeSetPageEvent(
                                              NavbarPage.explore));
                                    }
                                  },
                                  logoState:
                                      logoButtonState(homeState, exploreState),
                                  onPressedNews: () => context.homeBloc.add(
                                      const _HomeSetPageEvent(NavbarPage.news)),
                                  onPressedExplore: () {
                                    if (exploreState is _IExploreMatchedState) {
                                      context.exploreBloc
                                          .add(const _ExploreResetEvent());
                                    }
                                    context.homeBloc.add(
                                        const _HomeSetPageEvent(
                                            NavbarPage.explore));
                                  },
                                  onPressedOptions: () => context.homeBloc.add(
                                      const _HomeSetPageEvent(
                                          NavbarPage.options)),
                                  onPressedChat: () => context.homeBloc.add(
                                      const _HomeSetPageEvent(NavbarPage.chat)),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      );
}
