part of chat_page;

class _InitialState extends _IChatState {
  final CancelableOperation<Either<List<FriendsAndMessagesResponse>, Failure>>
      loadingMessages;

  const _InitialState({required this.loadingMessages}) : super();

  @override
  List<Object> get props => [loadingMessages.value];
}
