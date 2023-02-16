part of home_page;

extension _Bloc on BuildContext {
  _HomeBloc get bloc => read();

  void loadUser(GetUserResponse response) =>
      bloc.add(_LoadedUserEvent(response));

  void setExploreResponse(UserExploreResponse response) =>
      bloc.add(_SetExploreResponseEvent(response));
}

extension Auth on BuildContext {
  Future<Either<T, Failure>> withAuth<T>(
    Future<Either<T, Failure>> Function(String) f,
  ) =>
      f(bloc.state.accessToken).then(
        (either) => either.fold(
          (response) => Left(response),
          (failure) {
            if (failure == Failures.unauthorized.instance) {
              return Repositories.auth
                  .refreshSession(
                    email: bloc.state.user.email,
                    refreshToken: bloc.state.refreshToken,
                  )
                  .then(
                    (either) => either.fold(
                      (refreshResponse) {
                        bloc.add(_RefreshSessionEvent(refreshResponse));
                        return f(refreshResponse.accessToken);
                      },
                      (failure) => Repositories.auth
                          .login(
                            email: bloc.state.user.email,
                            password: bloc.state.password,
                          )
                          .then(
                            (either) => either.fold(
                              (loginResponse) {
                                bloc.add(_LoginEvent(loginResponse));
                                return f(loginResponse.accessToken);
                              },
                              (failure) {
                                bloc.add(_LogOutEvent());
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
  final LoginResponse initialData;
  final String initialPassword;

  const HomePage({
    Key? key,
    required this.initialData,
    required this.initialPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => _HomeBloc(
          initialData: initialData,
          initialPassword: initialPassword,
        ),
        child: BlocConsumer<_HomeBloc, _IHomeState>(
          listener: (context, state) {
            if (state is _LogOutConnectedState) {
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (_) => false,
              );
            }
          },
          builder: (context, state) => StyledScaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                height: 1.sh,
                child: Column(
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (state is _IExploreState) {
                            return ExplorePage(
                              gymId: state.gym.id,
                              logoPressStream:
                                  state.logoPress.stream.asBroadcastStream(),
                              initialData: state.userExploreResponse,
                              onLoaded: context.setExploreResponse,
                            );
                          } else if (state.currentPage == NavbarPage.chat) {
                            return ChatPage();
                          } else {
                            return OptionsPage(
                              initialUser: state.user,
                              initialGym: state.gym,
                              onLoadedUser: context.loadUser,
                            );
                          }
                        },
                      ),
                    ),
                    StyledNavBar(
                      page: state.currentPage,
                      onReleaseLogo: () {
                        if (state is _IExploreState) {
                          state.logoPress.add(PressType.up);
                        }
                      },
                      onPressDownLogo: () {
                        if (state is _IExploreState) {
                          state.logoPress.add(PressType.down);
                        } else {
                          context.bloc.add(_SetPageEvent(NavbarPage.explore));
                        }
                      },
                      onPressedNews: () =>
                          context.bloc.add(_SetPageEvent(NavbarPage.news)),
                      onPressedExplore: () =>
                          context.bloc.add(_SetPageEvent(NavbarPage.explore)),
                      onPressedOptions: () =>
                          context.bloc.add(_SetPageEvent(NavbarPage.options)),
                      onPressedChat: () =>
                          context.bloc.add(_SetPageEvent(NavbarPage.chat)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
