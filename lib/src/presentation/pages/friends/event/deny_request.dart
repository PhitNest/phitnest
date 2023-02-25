part of friends_page;

class _DenyRequestEvent extends _IFriendsEvent {
  final PublicUserEntity friend;

  const _DenyRequestEvent(this.friend) : super();
}
