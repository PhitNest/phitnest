part of explore_page;

extension _OnLoad on _ExploreBloc {
  void onLoad(_LoadEvent event, Emitter<_IExploreState> emit) => emit(
        _LoadingState(
          explore: CancelableOperation.fromFuture(
            withAuth(
              (accessToken) => Repositories.user.exploreUsers(
                accessToken: accessToken,
                gymId: Cache.gym!.id,
              ),
            ),
          )..then(
              (either) {
                add(
                  either.fold(
                    (response) => _LoadedEvent(response),
                    (failure) => _LoadingErrorEvent(failure),
                  ),
                );
              },
            ),
        ),
      );
}
