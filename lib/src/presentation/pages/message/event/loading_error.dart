part of message;

class _LoadingErrorEvent extends _IMessageEvent {
  final Failure failure;

  const _LoadingErrorEvent({required this.failure});
}
