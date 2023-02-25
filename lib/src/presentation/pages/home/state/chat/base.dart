part of home_page;

abstract class _IChatState {
  const _IChatState() : super();
}

mixin _IChatLoadingState on _IChatState {
  CancelableOperation<Either<List<FriendsAndMessagesResponse>, Failure>>
      get conversations;
}

abstract class _IChatLoadedState extends _IChatState {
  const _IChatLoadedState() : super();
}
