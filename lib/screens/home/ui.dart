part of 'home.dart';

class HomeScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  void goToLogin(BuildContext context, String? error) {
    if (error != null) {
      StyledBanner.show(message: error, error: true);
    }
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute<void>(
        builder: (context) => LoginScreen(apiInfo: apiInfo),
      ),
      (_) => false,
    );
  }

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
                apiInfo: apiInfo,
                load: (_, session) => exploreUsers(session),
                loadOnStart: (
                  req: (data: null, sessionLoader: context.sessionLoader)
                ),
              ),
            ),
            BlocProvider(
              create: (context) => UserBloc(
                apiInfo: apiInfo,
                load: (_, session) => getUser(session),
                loadOnStart: (
                  req: (data: null, sessionLoader: context.sessionLoader)
                ),
              ),
            ),
            BlocProvider(
              create: (context) => LogoutBloc(
                apiInfo: apiInfo,
                load: (_, session) => logout(
                    session: session, sessionLoader: context.sessionLoader),
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
                  goToLogin(context, null);
                default:
              }
            },
            builder: (context, logoutState) => switch (logoutState) {
              LoaderLoadingState() || LoaderLoadedState() => const Loader(),
              LoaderInitialState() => UserConsumer(
                  listener: (context, userLoaderState) {
                    switch (userLoaderState) {
                      case LoaderLoadedState(data: final response):
                        switch (response) {
                          case AuthLost(message: final message):
                            goToLogin(context, message);
                          case AuthRes(data: final response):
                            switch (response) {
                              case HttpResponseSuccess(data: final response):
                                switch (response) {
                                  case FailedToLoadProfilePicture():
                                    Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute<void>(
                                        builder: (context) =>
                                            PhotoInstructionsScreen(
                                          apiInfo: apiInfo,
                                        ),
                                      ),
                                    );
                                  case GetUserSuccess():
                                }
                              case HttpResponseFailure(failure: final failure):
                                StyledBanner.show(
                                  message: failure.message,
                                  error: true,
                                );
                                context.userBloc.add(LoaderLoadEvent((
                                  data: null,
                                  sessionLoader: context.sessionLoader
                                )));
                            }
                        }
                      default:
                    }
                  },
                  builder: (context, userLoaderState) =>
                      switch (userLoaderState) {
                    LoaderLoadedState(data: final getUserResponse) => switch (
                          getUserResponse) {
                        AuthLost() => const Loader(),
                        AuthRes(data: final getUserResponse) => switch (
                              getUserResponse) {
                            HttpResponseFailure() => const Loader(),
                            HttpResponseSuccess(data: final getUserResponse) =>
                              switch (getUserResponse) {
                                FailedToLoadProfilePicture() => const Loader(),
                                GetUserSuccess(
                                  profilePicture: final profilePicture
                                ) =>
                                  ExploreConsumer(
                                    listener: (context, exploreState) {
                                      switch (exploreState) {
                                        case LoaderLoadedState(
                                            data: final response
                                          ):
                                          switch (response) {
                                            case AuthLost(
                                                message: final message
                                              ):
                                              goToLogin(context, message);
                                            case AuthRes(data: final response):
                                              switch (response) {
                                                case HttpResponseSuccess(
                                                    data: final users
                                                  ):
                                                  context.homeBloc.add(
                                                      HomeLoadedExploreEvent(
                                                          users));
                                                case HttpResponseFailure():
                                                  context.exploreBloc.add(
                                                      LoaderLoadEvent((
                                                    data: null,
                                                    sessionLoader:
                                                        context.sessionLoader
                                                  )));
                                              }
                                          }
                                        default:
                                      }
                                    },
                                    builder: (context, exploreState) =>
                                        BlocConsumer<HomeBloc, HomeState>(
                                      listener: (context, homeState) {},
                                      builder: (context, homeState) =>
                                          StyledNavBar(
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
                                            NavBarPage.explore =>
                                              ExploreConsumer(
                                                listener:
                                                    (context, exploreState) {
                                                  switch (exploreState) {
                                                    case LoaderLoadedState(
                                                        data: final response
                                                      ):
                                                      switch (response) {
                                                        case AuthRes(
                                                            data: final response
                                                          ):
                                                          switch (response) {
                                                            // ignore: lines_longer_than_80_chars
                                                            case HttpResponseFailure(
                                                                failure:
                                                                    // ignore: lines_longer_than_80_chars
                                                                    final failure
                                                              ):
                                                              StyledBanner.show(
                                                                message: failure
                                                                    .message,
                                                                error: true,
                                                              );
                                                            default:
                                                          }
                                                        case AuthLost(
                                                            message:
                                                                final message
                                                          ):
                                                          goToLogin(
                                                              context, message);
                                                      }
                                                    default:
                                                  }
                                                },
                                                builder:
                                                    (context, exploreState) =>
                                                        switch (exploreState) {
                                                  LoaderLoadedState(
                                                    data: final exploreResponse
                                                  ) =>
                                                    switch (exploreResponse) {
                                                      AuthRes(
                                                        data:
                                                            // ignore: lines_longer_than_80_chars
                                                            final exploreResponse
                                                      ) =>
                                                        switch (
                                                            exploreResponse) {
                                                          HttpResponseSuccess(
                                                            data: final users
                                                          ) =>
                                                            ExploreScreen(
                                                              users: users,
                                                              // ignore: lines_longer_than_80_chars
                                                              pageController: context
                                                                  .homeBloc
                                                                  // ignore: lines_longer_than_80_chars
                                                                  .explorePageController,
                                                              // ignore: lines_longer_than_80_chars
                                                              countdown: switch (
                                                                  homeState) {
                                                                // ignore: lines_longer_than_80_chars
                                                                HomeHoldingLogoState(
                                                                  countdown:
                                                                      // ignore: lines_longer_than_80_chars
                                                                      final countdown
                                                                ) =>
                                                                  countdown,
                                                                _ => null,
                                                              },
                                                            ),
                                                          _ => const Loader(),
                                                        },
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
                                                  profilePicture,
                                                  StyledOutlineButton(
                                                    onPress: () => context
                                                        .logoutBloc
                                                        .add(LoaderLoadEvent((
                                                      data: null,
                                                      sessionLoader:
                                                          context.sessionLoader
                                                    ))),
                                                    text: 'Logout',
                                                  ),
                                                ],
                                              ),
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                              },
                          }
                      },
                    _ => const Loader(),
                  },
                )
            },
          ),
        ),
      );
}
