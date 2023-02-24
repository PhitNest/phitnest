part of home_page;

abstract class _IChatState extends Equatable {
  const _IChatState() : super();

  @override
  List<Object> get props => [];
}

mixin _IChatLoadingState on _IChatState {
  CancelableOperation<Either<List<FriendsAndMessagesResponse>, Failure>>
      get conversations;
}

abstract class _IChatLoadedState extends _IChatState {
  const _IChatLoadedState() : super();
}
