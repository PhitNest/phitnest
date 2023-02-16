part of home_page;

class _HomeBloc extends Bloc<_IHomeEvent, _IHomeState> {
  final LoginResponse initialData;
  final String initialPassword;

  _HomeBloc({
    required this.initialData,
    required this.initialPassword,
  }) : super(
          _ConnectingState(
            currentPage: NavbarPage.options,
            user: initialData.user,
            gym: initialData.gym,
            accessToken: initialData.accessToken,
            refreshToken: initialData.refreshToken,
            password: initialPassword,
            userExploreResponse: Cache.userExplore,
            socketConnection: CancelableOperation.fromFuture(
                connect(initialData.accessToken)),
          ),
        ) {
    on<_LoadedUserEvent>(onLoadedUser);
    on<_LogOutEvent>(onLogOut);
    on<_LoginEvent>(onLogin);
    on<_RefreshSessionEvent>(onRefreshSession);
    on<_SetPageEvent>(onSetPage);
    on<_SetExploreResponseEvent>(onSetExploreResponse);
  }

  @override
  Future<void> close() async {
    if (state is _IExploreState) {
      final state = this.state as _IExploreState;
      await state.logoPress.close();
    }
    return super.close();
  }
}
