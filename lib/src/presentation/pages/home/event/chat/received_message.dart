part of home_page;

class _ChatReceivedMessageEvent extends _IChatEvent {
  final FriendsAndMessagesResponse conversation;

  const _ChatReceivedMessageEvent(this.conversation) : super();
}
