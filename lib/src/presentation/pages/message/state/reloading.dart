part of message;

class _ReloadingState extends _ILoadedState with _ILoadingState {
  final CancelableOperation<Either<List<DirectMessageEntity>, Failure>>
      loadingMessage;

  const _ReloadingState({required this.loadingMessage});
}
