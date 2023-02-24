part of friends;

class _FriendsBloc extends Bloc<_IFriendsEvent, _IFriendsState> {
  final AuthMethods authMethods;

  _FriendsBloc({required this.authMethods})
      : super(
    Function.apply(() {
      final friendAndReq = CancelableOperation.fromFuture(
          authMethods.withAuth((accessToken) =>
              Repositories.friendship.friendsAndRequest(accessToken)));

      return Cache.friendship.friendsAndRequests != null
          ? _FriendsReloadingState(
        friendAndReq: friendAndReq,
      )
          : _FriendsLoadingState(
        friendAndReq: friendAndReq,
      );
    }, []),
  ) {
    // on<>((event, emit) => null);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
