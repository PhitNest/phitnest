part of message;

class _LoadingState extends _IMessageState with _ILoadingState {
  final CancelableOperation<Either<List<DirectMessageEntity>, Failure>>
      loadingMessage;

  const _LoadingState({required this.loadingMessage});
}
