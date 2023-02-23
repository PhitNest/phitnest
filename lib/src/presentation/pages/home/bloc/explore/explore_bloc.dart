part of home_page;

class _ExploreBloc extends Bloc<_IExploreEvent, _IExploreState> {
  final Future<Either<T, Failure>> Function<T>(
      Future<Either<T, Failure>> Function(String accessToken) f) withAuth;
  final Future<Either3<A, B, Failure>> Function<A, B>(
          Future<Either3<A, B, Failure>> Function(String accessToken) f)
      withAuthEither3;
  final Future<Failure?> Function(
      Future<Failure?> Function(String accessToken) f) withAuthVoid;

  _ExploreBloc({
    required this.withAuth,
    required this.withAuthVoid,
    required this.withAuthEither3,
  }) : super(
          Cache.user.userExploreResponse != null
              ? _ExploreReloadingState(
                  currentPageIndex: 0,
                  userExploreResponse: Cache.user.userExploreResponse!,
                  explore: CancelableOperation.fromFuture(
                    withAuth(
                      (String accessToken) => Repositories.user.exploreUsers(
                        accessToken: accessToken,
                        gymId: Cache.gym.gym!.id,
                      ),
                    ),
                  ),
                )
              : _ExploreLoadingState(
                  explore: CancelableOperation.fromFuture(
                    withAuth(
                      (String accessToken) => Repositories.user.exploreUsers(
                        accessToken: accessToken,
                        gymId: Cache.gym.gym!.id,
                      ),
                    ),
                  ),
                ),
        ) {
    on<_ExploreReleaseEvent>(onRelease);
    on<_ExplorePressDownEvent>(onPressDown);
    on<_ExploreIncrementCountdownEvent>(onIncrementCountdown);
    on<_ExploreLoadingErrorEvent>(onLoadingError);
    on<_ExploreLoadedEvent>(onLoaded);
    on<_ExploreSetPageEvent>(onSetPage);
    if (state is _IExploreLoadingState) {
      final state = this.state as _IExploreLoadingState;
      state.explore.then(
        (either) => add(
          either.fold(
            (response) => _ExploreLoadedEvent(response),
            (failure) => _ExploreLoadingErrorEvent(failure),
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    if (state is _ExploreLoadingState) {
      final _ExploreLoadingState state = this.state as _ExploreLoadingState;
      await state.explore.cancel();
    }
    if (state is _ExploreReloadingState) {
      final _ExploreReloadingState state = this.state as _ExploreReloadingState;
      await state.explore.cancel();
    }
    if (state is _IExploreHoldingState) {
      final _IExploreHoldingState state = this.state as _IExploreHoldingState;
      await state.incrementCountdown.cancel();
    }
    if (state is _IExploreSendingFriendRequestState) {
      final _IExploreSendingFriendRequestState state =
          this.state as _IExploreSendingFriendRequestState;
      await state.sendRequest.cancel();
    }
    super.close();
  }
}

extension _ExploreBlocExt on BuildContext {
  _ExploreBloc get exploreBloc => read();
}
