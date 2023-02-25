part of home_page;

class _HomeSocketConnectedState extends IHomeState {
  final SocketConnection connection;
  final CancelableOperation<void> onDisconnect;

  _HomeSocketConnectedState({
    required super.currentPage,
    required this.connection,
    required this.onDisconnect,
  }) : super();
}
