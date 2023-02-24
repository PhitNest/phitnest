part of home_page;

class _ChatReloadingState extends _IChatLoadedState with _IChatLoadingState {
  final CancelableOperation<Either<List<FriendsAndMessagesResponse>, Failure>>
      conversations;

  _ChatReloadingState({
    required this.conversations,
  }) : super();

  @override
  List<Object> get props => [super.props, conversations.value];
}
