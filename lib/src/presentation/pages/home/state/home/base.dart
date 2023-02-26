part of home_page;

abstract class IHomeState {
  final NavbarPage currentPage;

  const IHomeState({
    required this.currentPage,
  }) : super();
}

abstract class _IHomeSocketConnectedState extends IHomeState {
  final SocketConnection connection;
  final CancelableOperation<void> onDisconnect;

  const _IHomeSocketConnectedState({
    required super.currentPage,
    required this.connection,
    required this.onDisconnect,
  }) : super();
}
