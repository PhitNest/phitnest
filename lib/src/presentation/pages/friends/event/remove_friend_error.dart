part of friends_page;

class _RemoveFriendErrorEvent extends _IFriendsEvent {
  final PublicUserEntity friend;
  final Failure failure;

  const _RemoveFriendErrorEvent({
    required this.friend,
    required this.failure,
  }) : super();
}
