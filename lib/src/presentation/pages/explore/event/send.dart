part of explore_page;

class _SendFriendRequestEvent extends _IExploreEvent {
  final String recipientCognitoId;

  const _SendFriendRequestEvent(this.recipientCognitoId) : super();
}
