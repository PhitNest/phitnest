part of friends_page;

abstract class _IFriendsState {
  const _IFriendsState();
}

abstract class _ILoadedState extends _IFriendsState {
  final Map<
          String,
          CancelableOperation<
              Either3<FriendRequestEntity, FriendshipEntity, Failure>>>
      sendingRequests;
  final Map<String, CancelableOperation<Failure?>> denyingRequests;
  final Map<String, CancelableOperation<Failure?>> removingFriends;

  _ILoadedState copyWith({
    Map<
            String,
            CancelableOperation<
                Either3<FriendRequestEntity, FriendshipEntity, Failure>>>?
        sendingRequests,
    Map<String, CancelableOperation<Failure?>>? denyingRequests,
    Map<String, CancelableOperation<Failure?>>? removingFriends,
  });

  const _ILoadedState({
    required this.sendingRequests,
    required this.denyingRequests,
    required this.removingFriends,
  });
}

mixin _ILoadingState on _IFriendsState {
  CancelableOperation<Either<FriendsAndRequestsResponse, Failure>>
      get friendsAndRequests;
}
