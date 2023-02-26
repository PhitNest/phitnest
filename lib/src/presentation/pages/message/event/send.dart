part of message;

class _SendEvent extends _IMessageEvent {
  final SocketConnection connection;

  const _SendEvent(this.connection) : super();
}
