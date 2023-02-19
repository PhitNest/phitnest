part of home_page;

class _SocketConnectedEvent extends _IHomeEvent {
  final SocketConnection connection;

  const _SocketConnectedEvent(this.connection) : super();

  @override
  List<Object> get props => [connection];
}
