part of home_page;

extension HomeBloc on BuildContext {
  _HomeBloc get homeBloc => read();

  Future<Either<T, Failure>> withAuth<T>(
    Future<Either<T, Failure>> Function(String) f,
  ) =>
      f(homeBloc.state.accessToken).then(
        (either) => either.fold(
          (response) => Left(response),
          (failure) {
            if (failure == Failures.unauthorized.instance) {
              return Repositories.auth
                  .refreshSession(
                    email: homeBloc.state.user.email,
                    refreshToken: homeBloc.state.refreshToken,
                  )
                  .then(
                    (either) => either.fold(
                      (refreshResponse) {
                        homeBloc.add(_RefreshSessionEvent(refreshResponse));
                        return f(refreshResponse.accessToken);
                      },
                      (failure) => Repositories.auth
                          .login(
                            email: homeBloc.state.user.email,
                            password: homeBloc.state.password,
                          )
                          .then(
                            (either) => either.fold(
                              (loginResponse) {
                                homeBloc.add(_LoginEvent(loginResponse));
                                return f(loginResponse.accessToken);
                              },
                              (failure) {
                                homeBloc.add(_LogOutEvent());
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
        child: BlocConsumer<_HomeBloc, _HomeState>(
          listener: (context, state) {
            if (state is _LogOutState) {
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (_) => false,
              );
            }
          },
          builder: (context, state) => Scaffold(
            body: Center(
              child: OptionsPage(
                initialGym: state.gym,
                initialUser: state.user,
              ),
            ),
            bottomNavigationBar: StyledNavigationBar(),
          ),
        ),
      );
}
