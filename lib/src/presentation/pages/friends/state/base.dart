part of friends_page;

abstract class _IFriendsState {
  const _IFriendsState();
}

abstract class _ILoadedState extends _IFriendsState {
  final TextEditingController searchController;

  const _ILoadedState({
    required this.searchController,
  });
}

mixin _ILoadingState on _IFriendsState {
  CancelableOperation<Either<FriendsAndRequestsResponse, Failure>>
      get friendsAndRequests;
}
