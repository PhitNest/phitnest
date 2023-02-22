part of home_page;

class _ExploreSendFriendRequestEvent extends _IExploreEvent {
  final String recipientCognitoId;

  const _ExploreSendFriendRequestEvent(this.recipientCognitoId) : super();
}
