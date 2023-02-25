part of message;

class _SendErrorEvent extends _IMessageEvent {
  final Failure failure;

  const _SendErrorEvent({required this.failure});
}
