part of chat_page;

class _MessagesLoadedEvent extends _IChatEvent {
  final List<FriendsAndMessagesResponse> messages;

  const _MessagesLoadedEvent({required this.messages}) : super();
}
