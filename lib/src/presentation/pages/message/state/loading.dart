part of message;

class _LoadingState extends _IMessageState {
  final CancelableOperation<Either<List<DirectMessageEntity>, Failure>>
      loadingMessage;

  const _LoadingState({required this.loadingMessage});
}
