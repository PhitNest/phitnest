part of home_page;

class HomeInitialState extends IHomeState {
  final CancelableOperation<Either<SocketConnection, Failure>> socketConnection;

  HomeInitialState({
    required super.currentPage,
    required this.socketConnection,
  }) : super();
}
