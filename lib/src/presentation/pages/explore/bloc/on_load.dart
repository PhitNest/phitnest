part of explore_page;

extension _OnLoad on _ExploreBloc {
  void onLoad(_LoadEvent event, Emitter<_ExploreState> emit) => emit(
        _LoadingState(
          explore: CancelableOperation.fromFuture(
            withAuth(
              (accessToken) => Repositories.user.exploreUsers(
                accessToken: accessToken,
                gymId: gymId,
              ),
            ),
          )..then(
              (either) => either.fold(
                (response) => add(_LoadedEvent(response)),
                (failure) => add(_LoadingErrorEvent(failure)),
              ),
            ),
        ),
      );
}
