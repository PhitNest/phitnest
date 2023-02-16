part of home_page;

abstract class _IHomeState extends Equatable {
  final ProfilePictureUserEntity user;
  final GymEntity gym;
  final String accessToken;
  final String refreshToken;
  final String password;
  final UserExploreResponse? userExploreResponse;
  final NavbarPage currentPage;

  const _IHomeState({
    required this.user,
    required this.gym,
    required this.accessToken,
    required this.refreshToken,
    required this.password,
    required this.currentPage,
    required this.userExploreResponse,
  }) : super();

  @override
  List<Object> get props => [
        user,
        gym,
        accessToken,
        refreshToken,
        password,
        currentPage,
        userExploreResponse ?? "",
      ];
}

abstract class _ISocketConnectedState extends _IHomeState {
  final SocketConnection socketConnection;

  const _ISocketConnectedState({
    required super.user,
    required super.gym,
    required super.accessToken,
    required super.refreshToken,
    required super.password,
    required super.currentPage,
    required super.userExploreResponse,
    required this.socketConnection,
  }) : super();

  @override
  List<Object> get props => [...super.props, socketConnection];
}

abstract class _ISocketDisconnectedState extends _IHomeState {
  final Failure failure;

  const _ISocketDisconnectedState({
    required super.user,
    required super.gym,
    required super.accessToken,
    required super.refreshToken,
    required super.password,
    required super.currentPage,
    required super.userExploreResponse,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [...super.props, failure];
}
