part of friends_page;

class _FriendsBloc extends Bloc<_IFriendsEvent, _IFriendsState> {
  final AuthMethods authMethods;
  final searchController = TextEditingController();

  _FriendsBloc({
    required this.authMethods,
  }) : super(
          Function.apply(
            () {
              final friendsAndRequests = CancelableOperation.fromFuture(
                authMethods.withAuth(
                  (accessToken) =>
                      Repositories.friendship.friendsAndRequests(accessToken),
                ),
              );
              return Cache.friendship.friendsAndRequests != null
                  ? _ReloadingState(
                      friendsAndRequests: friendsAndRequests,
                      sendingRequests: {},
                      denyingRequests: {},
                      removingFriends: {},
                    )
                  : _LoadingState(
                      friendsAndRequests: friendsAndRequests,
                    );
            },
            [],
          ),
        ) {
    searchController.addListener(
      () => add(
        _EditSearchEvent(),
      ),
    );
    on<_LoadedEvent>(onLoaded);
    on<_LoadingErrorEvent>(onLoadingError);
    on<_EditSearchEvent>(onEditSearch);
    on<_AddFriendEvent>(onAddFriend);
    on<_RemoveFriendEvent>(onRemoveFriend);
    on<_DenyRequestEvent>(onDenyRequest);
    on<_AddFriendErrorEvent>(onAddFriendError);
    on<_AddFriendSuccessEvent>(onAddFriendSuccess);
    on<_RemoveFriendErrorEvent>(onRemoveFriendError);
    on<_RemoveFriendSuccessEvent>(onRemoveFriendSuccess);
    on<_DenyRequestErrorEvent>(onDenyRequestError);
    on<_DenyRequestSuccessEvent>(onDenyRequestSuccess);
    if (state is _ILoadingState) {
      final state = this.state as _ILoadingState;
      state.friendsAndRequests.then(
        (either) => add(
          either.fold(
            (response) => const _LoadedEvent(),
            (failure) => _LoadingErrorEvent(failure),
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    searchController.dispose();
    if (state is _ILoadedState) {
      final state = this.state as _ILoadedState;
      await Future.wait([
        state.denyingRequests,
        state.removingFriends,
        state.sendingRequests
      ]
          .map((map) => map.entries)
          .expand((entries) => entries)
          .map((entry) => entry.value.cancel()));
    }
    if (state is _ILoadingState) {
      final state = this.state as _ILoadingState;
      await state.friendsAndRequests.cancel();
    }
    return super.close();
  }
}

extension _FriendsBlocExt on BuildContext {
  _FriendsBloc get bloc => read();
}
