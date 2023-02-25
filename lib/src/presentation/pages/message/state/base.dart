part of message;

abstract class _IMessageState {
  const _IMessageState();
}

abstract class _ILoadedState extends _IMessageState {
  const _ILoadedState();
}

mixin _ILoadingState on _IMessageState {
  CancelableOperation<Either<List<DirectMessageEntity>, Failure>>
      get loadingMessage;
}
