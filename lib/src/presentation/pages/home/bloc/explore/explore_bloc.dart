part of home_page;

class _ExploreBloc extends Bloc<_IExploreEvent, _IExploreState> {
  final AuthMethods authMethods;

  _ExploreBloc({
    required this.authMethods,
  }) : super(
          Function.apply(
            () {
              final explore = CancelableOperation.fromFuture(
                authMethods.withAuth(
                  (String accessToken) => Repositories.user.exploreUsers(
                    accessToken: accessToken,
                    gymId: Cache.gym.gym!.id,
                  ),
                ),
              );
              return Cache.user.userExploreResponse != null
                  ? _ExploreReloadingState(
                      currentPageIndex: 0,
                      explore: explore,
                    )
                  : _ExploreLoadingState(
                      explore: explore,
                    );
            },
            [],
          ),
        ) {
    on<_ExploreReleaseEvent>(onRelease);
    on<_ExplorePressDownEvent>(onPressDown);
    on<_ExploreIncrementCountdownEvent>(onIncrementCountdown);
    on<_ExploreLoadingErrorEvent>(onLoadingError);
    on<_ExploreLoadedEvent>(onLoaded);
    on<_ExploreSetPageEvent>(onSetPage);
    on<_ExploreSendFriendRequestErrorEvent>(onFriendRequestError);
    on<_ExploreResetEvent>(onReset);
    on<_ExploreFriendshipResponseEvent>(onFriendshipResponse);
    if (state is _IExploreLoadingState) {
      final state = this.state as _IExploreLoadingState;
      state.explore.then(
        (either) => add(
          either.fold(
            (response) => const _ExploreLoadedEvent(),
            (failure) => _ExploreLoadingErrorEvent(failure),
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    if (state is _IExploreLoadingState) {
      final state = this.state as _IExploreLoadingState;
      await state.explore.cancel();
    }
    if (state is _IExploreHoldingState) {
      final state = this.state as _IExploreHoldingState;
      await state.incrementCountdown.cancel();
    }
    if (state is _IExploreSendingFriendRequestState) {
      final state = this.state as _IExploreSendingFriendRequestState;
      await state.sendRequest.cancel();
    }
    super.close();
  }
}

extension _ExploreBlocExt on BuildContext {
  _ExploreBloc get exploreBloc => read();
}
