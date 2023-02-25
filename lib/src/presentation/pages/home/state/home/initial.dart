part of home_page;

class _HomeInitialState extends _IHomeState {
  final CancelableOperation<Either<SocketConnection, Failure>> socketConnection;

  _HomeInitialState({
    required super.currentPage,
    required this.socketConnection,
  }) : super();
}
