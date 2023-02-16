part of home_page;

class _SocketDisconnectedState extends _ISocketDisconnectedState {
  const _SocketDisconnectedState({
    required super.user,
    required super.gym,
    required super.accessToken,
    required super.refreshToken,
    required super.password,
    required super.currentPage,
    required super.userExploreResponse,
    required super.failure,
  }) : super();
}
