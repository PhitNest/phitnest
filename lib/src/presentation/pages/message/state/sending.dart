part of message;

class _SendingState extends _IMessageState {
  final CancelableOperation<Either<DirectMessageEntity, Failure>> sending;

  const _SendingState({required this.sending});
}