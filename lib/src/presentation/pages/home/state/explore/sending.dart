part of home_page;

class _ExploreSendingFriendRequestState extends _IExploreLoadedState
    with _IExploreSendingFriendRequestState {
  final CancelableOperation<
      Either3<FriendRequestEntity, FriendshipEntity, Failure>> sendRequest;

  const _ExploreSendingFriendRequestState({
    required this.sendRequest,
  }) : super();
}

class _ExploreSendingFriendRequestReloadingState extends _IExploreReloadingState
    with _IExploreSendingFriendRequestState {
  final CancelableOperation<
      Either3<FriendRequestEntity, FriendshipEntity, Failure>> sendRequest;

  const _ExploreSendingFriendRequestReloadingState({
    required super.explore,
    required this.sendRequest,
  }) : super();
}
