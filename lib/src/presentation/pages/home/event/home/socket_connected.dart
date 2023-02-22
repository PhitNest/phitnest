part of home_page;

class _HomeSocketConnectedEvent extends _IHomeEvent {
  final SocketConnection connection;

  const _HomeSocketConnectedEvent(this.connection) : super();
}
