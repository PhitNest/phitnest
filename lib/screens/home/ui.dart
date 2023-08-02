part of 'home.dart';

class HomeScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  void goToLogin(
    BuildContext context,
  ) =>
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute<void>(
          builder: (context) => LoginScreen(apiInfo: apiInfo),
        ),
        (_) => false,
      );

  const HomeScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ExploreBloc(
                load: (_) => context.sessionLoader.session.then(
                  (session) => session != null ? explore(session) : null,
                ),
                loadOnStart: (req: null),
              ),
            ),
            BlocProvider(
              create: (context) => UserBloc(
                load: (_) => context.sessionLoader.session.then(
                  (session) => session != null ? getUser(session) : null,
                ),
                loadOnStart: (req: null),
              ),
            ),
            BlocProvider(
              create: (context) => LogoutBloc(
                load: (_) async {
                  final session = await context.sessionLoader.session;
                  if (session != null) {
                    await cacheUser(null);
                    await logout(session: session);
                  }
                },
              ),
            ),
            BlocProvider(
              create: (_) => HomeBloc(),
            ),
          ],
          child: LogoutConsumer(
            listener: (context, logoutState) {
              switch (logoutState) {
                case LoaderLoadedState():
                  goToLogin(context);
                default:
              }
            },
            builder: (context, logoutState) => switch (logoutState) {
              LoaderInitialState() => UserConsumer(
                  listener: (context, userLoaderState) {
                    switch (userLoaderState) {
                      case LoaderLoadedState(data: final response):
                        if (response == null) {
                          goToLogin(context);
                        } else {
                          switch (response) {
                            case FailedToLoadProfilePicture():
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute<void>(
                                  builder: (context) => PhotoInstructionsScreen(
                                    apiInfo: apiInfo,
                                  ),
                                ),
                              );
                            case FailedToLoadUser(error: final error):
                              StyledBanner.show(
                                message: error.message,
                                error: true,
                              );
                              context.userBloc.add(const LoaderLoadEvent(null));
                            case GetUserSuccess():
                          }
                        }
                      default:
                    }
                  },
                  builder: (context, userState) => switch (userState) {
                    LoaderLoadedState(data: final getUserResponse) => switch (
                          getUserResponse) {
                        GetUserSuccess(user: final user) => ExploreConsumer(
                            listener: (context, exploreState) {
                              switch (exploreState) {
                                case LoaderLoadedState(data: final response):
                                  if (response != null) {
                                    switch (response) {
                                      case HttpResponseSuccess(
                                          data: final users
                                        ):
                                        context.homeBloc
                                            .add(HomeLoadedExploreEvent(users));
                                      case HttpResponseFailure():
                                        context.exploreBloc
                                            .add(const LoaderLoadEvent(null));
                                    }
                                  } else {
                                    goToLogin(context);
                                  }
                                default:
                              }
                            },
                            builder: (context, exploreState) =>
                                BlocConsumer<HomeBloc, HomeState>(
                              listener: (context, homeState) {},
                              builder: (context, homeState) => StyledNavBar(
                                state: homeState,
                                builder: (context) => Expanded(
                                  child: switch (homeState.page) {
                                    NavBarPage.news => const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('News screen'),
                                          Text('Coming soon'),
                                        ],
                                      ),
                                    NavBarPage.explore => ExploreConsumer(
                                        listener: (context, exploreState) {
                                          switch (exploreState) {
                                            case LoaderLoadedState(
                                                data: final response
                                              ):
                                              switch (response) {
                                                case HttpResponseFailure(
                                                    failure: final failure
                                                  ):
                                                  StyledBanner.show(
                                                    message: failure.message,
                                                    error: true,
                                                  );
                                                default:
                                              }
                                            default:
                                          }
                                        },
                                        builder: (context, exploreState) =>
                                            switch (exploreState) {
                                          LoaderLoadedState(
                                            data: final exploreResponse
                                          ) =>
                                            switch (exploreResponse) {
                                              HttpResponseSuccess(
                                                data: final users
                                              ) =>
                                                ExploreScreen(
                                                  users: users,
                                                  pageController: context
                                                      .homeBloc
                                                      .explorePageController,
                                                  countdown: switch (
                                                      homeState) {
                                                    HomeHoldingLogoState(
                                                      countdown: final countdown
                                                    ) =>
                                                      countdown,
                                                    _ => null,
                                                  },
                                                ),
                                              _ => const Loader(),
                                            },
                                          _ => const Loader(),
                                        },
                                      ),
                                    NavBarPage.chat => const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Chat screen'),
                                          Text('Coming soon'),
                                        ],
                                      ),
                                    NavBarPage.options => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('Options screen'),
                                          20.verticalSpace,
                                          user.profilePicture,
                                          StyledOutlineButton(
                                            onPress: () => context.logoutBloc
                                                .add(const LoaderLoadEvent(
                                                    null)),
                                            text: 'Logout',
                                          ),
                                        ],
                                      ),
                                  },
                                ),
                              ),
                            ),
                          ),
                        _ => const Loader(),
                      },
                    _ => const Loader(),
                  },
                ),
              _ => const Loader(),
            },
          ),
        ),
      );
}
