part of friends_page;

extension _OnLoadingError on _FriendsBloc {
  void onLoadingError(_LoadingErrorEvent event, Emitter<_IFriendsState> emit) {
    StyledErrorBanner.show(event.failure);
    final friendsAndRequests = CancelableOperation.fromFuture(
      authMethods.withAuth(
        (accessToken) =>
            Repositories.friendship.friendsAndRequests(accessToken),
      ),
    )..then(
        (res) => add(
          res.fold(
            (success) => const _LoadedEvent(),
            (failure) => _LoadingErrorEvent(failure),
          ),
        ),
      );
    if (state is _ILoadedState) {
      final state = this.state as _ILoadedState;
      emit(
        _ReloadingState(
          friendsAndRequests: friendsAndRequests,
          sendingRequests: state.sendingRequests,
          removingFriends: state.removingFriends,
          denyingRequests: state.denyingRequests,
        ),
      );
    } else {
      emit(_LoadingState(friendsAndRequests: friendsAndRequests));
    }
  }
}
