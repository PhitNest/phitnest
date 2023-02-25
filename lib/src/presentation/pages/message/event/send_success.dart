part of message;

class _SendSuccessEvent extends _IMessageEvent {
  final DirectMessageEntity newMessage;

  const _SendSuccessEvent({required this.newMessage});
}
