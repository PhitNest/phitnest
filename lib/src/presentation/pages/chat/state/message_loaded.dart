part of chat_page;

class _MessagesLoadedState extends _ChatState {
  final List<FriendsAndMessagesResponse> messages;

  const _MessagesLoadedState({required this.messages}) : super();

  @override
  List<Object> get props => [messages];
}
