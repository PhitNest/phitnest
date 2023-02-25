part of friends_page;

class _LoadedState extends _ILoadedState {
  const _LoadedState({
    required super.sendingRequests,
    required super.denyingRequests,
    required super.removingFriends,
  }) : super();

  @override
  _LoadedState copyWith(
          {Map<
                  String,
                  CancelableOperation<
                      Either3<FriendRequestEntity, FriendshipEntity, Failure>>>?
              sendingRequests,
          Map<String, CancelableOperation<Failure?>>? denyingRequests,
          Map<String, CancelableOperation<Failure?>>? removingFriends}) =>
      _LoadedState(
        sendingRequests: sendingRequests ?? this.sendingRequests,
        denyingRequests: denyingRequests ?? this.denyingRequests,
        removingFriends: removingFriends ?? this.removingFriends,
      );
}
