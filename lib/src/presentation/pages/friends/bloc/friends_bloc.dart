part of friends_page;

class _FriendsBloc extends Bloc<_IFriendsEvent, _IFriendsState> {
  final AuthMethods authMethods;

  _FriendsBloc({required this.authMethods})
      : super(
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
                      searchController: TextEditingController(),
                    )
                  : _LoadingState(
                      friendsAndRequests: friendsAndRequests,
                    );
            },
            [],
          ),
        ) {
    on<_LoadedEvent>(onLoaded);
    on<_LoadingErrorEvent>(onLoadingError);
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
    if (state is _ILoadedState) {
      final state = this.state as _ILoadedState;
      state.searchController.dispose();
    }
    if (state is _ILoadingState) {
      final state = this.state as _ILoadingState;
      await state.friendsAndRequests.cancel();
    }
    return super.close();
  }
}
