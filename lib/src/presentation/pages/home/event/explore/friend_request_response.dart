part of home_page;

class _ExploreFriendRequestResponseEvent extends _IExploreEvent {
  final FriendRequestEntity friendRequest;

  const _ExploreFriendRequestResponseEvent(this.friendRequest) : super();
}
