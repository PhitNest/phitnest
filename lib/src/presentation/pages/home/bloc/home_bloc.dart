part of home_page;

class _HomeBloc extends Bloc<_HomeEvent, _HomeState> {
  final LoginResponse initialData;
  final String initialPassword;

  _HomeBloc({
    required this.initialData,
    required this.initialPassword,
  }) : super(
          _InitialState(
            user: initialData.user,
            gym: initialData.gym,
            accessToken: initialData.accessToken,
            refreshToken: initialData.refreshToken,
          ),
        ) {
    on<_LoadedUserEvent>(onLoadedUser);
  }

  void loadUser(GetUserResponse response) => add(_LoadedUserEvent(response));
}
