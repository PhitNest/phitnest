part of home_page;

class _LogOutConnectedState extends _ISocketConnectedState {
  const _LogOutConnectedState({
    required super.user,
    required super.gym,
    required super.accessToken,
    required super.refreshToken,
    required super.password,
    required super.currentPage,
    required super.userExploreResponse,
    required super.socketConnection,
  }) : super();
}
