part of home_page;

class _ConnectingState extends _IHomeState {
  final CancelableOperation<Either<SocketConnection, Failure>> socketConnection;

  const _ConnectingState({
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
  List<Object> get props => [super.props, socketConnection];
}
