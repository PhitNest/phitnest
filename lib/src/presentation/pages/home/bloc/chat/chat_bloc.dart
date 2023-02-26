part of home_page;

class _ChatBloc extends Bloc<_IChatEvent, _IChatState> {
  final AuthMethods authMethods;

  _ChatBloc({
    required this.authMethods,
  }) : super(
          Function.apply(
            () {
              final conversations = CancelableOperation.fromFuture(
                authMethods.withAuth(
                  (accessToken) =>
                      Repositories.friendship.friendsAndMessages(accessToken),
                ),
              );
              return Cache.friendship.friendsAndMessages != null
                  ? _ChatReloadingState(
                      conversations: conversations,
                    )
                  : _ChatLoadingState(
                      conversations: conversations,
                    );
            },
            [],
          ),
        ) {
    on<_ChatLoadedEvent>(onLoaded);
    on<_ChatLoadingErrorEvent>(onLoadingError);
    on<_ChatReceivedMessageEvent>(onReceivedMessage);
    on<_ChatFriendsAndRequestsUpdatedEvent>(onFriendsAndRequestsUpdated);
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

extension _ChatBlocExt on BuildContext {
  _ChatBloc get chatBloc => read();
}
