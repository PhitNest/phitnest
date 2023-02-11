part of home_page;

class _HomeBloc extends Bloc<_HomeEvent, _HomeState> {
  final LoginResponse initialData;
  final String initialPassword;

  _HomeBloc({
    required this.initialData,
    required this.initialPassword,
  }) : super(
          _InitialState(
            currentPage: NavbarPage.options,
            user: initialData.user,
            gym: initialData.gym,
            accessToken: initialData.accessToken,
            refreshToken: initialData.refreshToken,
            password: initialPassword,
          ),
        ) {
    on<_LoadedUserEvent>(onLoadedUser);
    on<_LogOutEvent>(onLogOut);
    on<_LoginEvent>(onLogin);
    on<_RefreshSessionEvent>(onRefreshSession);
    on<_SetPageEvent>(onSetPage);
  }

  @override
  Future<void> close() async {
    if (state is _ExploreState) {
      final state = this.state as _ExploreState;
      await state.logoPress.close();
    }
    return super.close();
  }
}
