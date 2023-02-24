part of home_page;

class _ExploreSendFriendRequestErrorEvent extends _IExploreEvent {
  final Failure failure;

  const _ExploreSendFriendRequestErrorEvent(this.failure) : super();
}
