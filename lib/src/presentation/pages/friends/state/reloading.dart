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

  @override
  _ReloadingState copyWith({
    Map<
            String,
            CancelableOperation<
                Either3<FriendRequestEntity, FriendshipEntity, Failure>>>?
        sendingRequests,
    Map<String, CancelableOperation<Failure?>>? denyingRequests,
    Map<String, CancelableOperation<Failure?>>? removingFriends,
    CancelableOperation<Either<FriendsAndRequestsResponse, Failure>>?
        friendsAndRequests,
  }) =>
      _ReloadingState(
        sendingRequests: sendingRequests ?? this.sendingRequests,
        denyingRequests: denyingRequests ?? this.denyingRequests,
        removingFriends: removingFriends ?? this.removingFriends,
        friendsAndRequests: friendsAndRequests ?? this.friendsAndRequests,
      );
}
