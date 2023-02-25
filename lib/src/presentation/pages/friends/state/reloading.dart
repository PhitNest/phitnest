part of friends_page;

class _ReloadingState extends _ILoadedState with _ILoadingState {
  final CancelableOperation<Either<FriendsAndRequestsResponse, Failure>>
      friendsAndRequests;

  const _ReloadingState({
    required super.sendingRequests,
    required super.denyingRequests,
    required super.removingFriends,
    required this.friendsAndRequests,
  }) : super();
}
