part of friends_page;

extension _OnLoadingError on _FriendsBloc {
  void onLoadingError(_LoadingErrorEvent event, Emitter<_IFriendsState> emit) {
    StyledErrorBanner.show(event.failure);
    emit(
      _LoadingState(
        friendsAndRequests: CancelableOperation.fromFuture(
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
          ),
      ),
    );
  }
}
