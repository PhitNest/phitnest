part of home_page;

class _ChatLoadingState extends _IChatState with _IChatLoadingState {
  final CancelableOperation<Either<List<FriendsAndMessagesResponse>, Failure>>
      conversations;

  const _ChatLoadingState({
    required this.conversations,
  }) : super();

  @override
  List<Object> get props => [conversations.value];
}
