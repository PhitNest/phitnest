part of chat_page;

class _MessagesLoadedEvent extends _ChatEvent {
  final List<FriendsAndMessagesResponse> messages;

  const _MessagesLoadedEvent({required this.messages}) : super();

  @override
  List<Object> get props => [messages];
}
