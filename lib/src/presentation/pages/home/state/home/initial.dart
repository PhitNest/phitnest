part of home_page;

class _HomeInitialState extends IHomeState {
  final CancelableOperation<Either<SocketConnection, Failure>> socketConnection;

  _HomeInitialState({
    required super.currentPage,
    required this.socketConnection,
  }) : super();
}
