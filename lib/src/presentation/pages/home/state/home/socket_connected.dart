part of home_page;

class HomeSocketConnectedState extends IHomeState {
  final SocketConnection connection;
  final CancelableOperation<void> onDisconnect;
  final StreamSubscription<void> onDataUpdated;

  HomeSocketConnectedState({
    required super.currentPage,
    required this.connection,
    required this.onDisconnect,
    required this.onDataUpdated,
  }) : super();
}
