part of home_page;

class _ChatLoadedEvent extends _IChatEvent {
  final List<FriendsAndMessagesResponse> response;

  const _ChatLoadedEvent(this.response) : super();
}
