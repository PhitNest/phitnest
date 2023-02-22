part of home_page;

class _ChatBloc extends Bloc<_IChatEvent, _IChatState> {
  final Future<Either<T, Failure>> Function<T>(
      Future<Either<T, Failure>> Function(String accessToken) f) withAuth;
  final Future<Failure?> Function(
      Future<Failure?> Function(String accessToken) f) withAuthVoid;

  _ChatBloc({
    required this.withAuth,
    required this.withAuthVoid,
  }) : super(
          Cache.friendship.friendsAndMessages != null
              ? _ChatReloadingState(
                  response: Cache.friendship.friendsAndMessages!,
                  conversations: CancelableOperation.fromFuture(
                    withAuth(
                      (accessToken) =>
                          Repositories.friendship.friendsAndMessages(
                        Cache.auth.accessToken!,
                      ),
                    ),
                  ),
                )
              : _ChatLoadingState(
                  conversations: CancelableOperation.fromFuture(
                    withAuth(
                      (accessToken) =>
                          Repositories.friendship.friendsAndMessages(
                        accessToken,
                      ),
                    ),
                  ),
                ),
        ) {
    on<_ChatLoadedEvent>(onLoaded);
    on<_ChatLoadingErrorEvent>(onLoadingError);
    if (state is _IChatLoadingState) {
      final state = this.state as _IChatLoadingState;
      state.conversations.then(
        (either) => add(
          either.fold(
            (response) => _ChatLoadedEvent(response),
            (failure) => _ChatLoadingErrorEvent(failure),
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    if (state is _ChatLoadingState) {
      final _ChatLoadingState state = this.state as _ChatLoadingState;
      state.conversations.cancel();
    }
    if (state is _ChatReloadingState) {
      final _ChatReloadingState state = this.state as _ChatReloadingState;
      state.conversations.cancel();
    }
    return super.close();
  }
}
