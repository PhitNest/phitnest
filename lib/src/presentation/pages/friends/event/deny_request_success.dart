part of friends_page;

class _DenyRequestSuccessEvent extends _IFriendsEvent {
  final PublicUserEntity friend;

  const _DenyRequestSuccessEvent(this.friend) : super();
}
