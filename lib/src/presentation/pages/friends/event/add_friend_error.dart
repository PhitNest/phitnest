part of friends_page;

class _AddFriendErrorEvent extends _IFriendsEvent {
  final PublicUserEntity friend;
  final Failure failure;

  const _AddFriendErrorEvent({
    required this.friend,
    required this.failure,
  }) : super();
}
