part of chat_page;

class _ChatBloc extends Bloc<_ChatEvent, _ChatState> {
  final T Function<T>(T Function(String accessToken) f) withAuth;

  _ChatBloc({required this.withAuth})
      : super(
          _InitialState(
            loadingMessages: CancelableOperation.fromFuture(
              withAuth(
                (accessToken) => Backend.friendships
                    .friendsAndMessages(accessToken: accessToken),
              ),
            ),
          ),
        ) {
    if (state is _InitialState) {
      final _InitialState state = this.state as _InitialState;
      state.loadingMessages.then((value) => value.fold(
            (messages) => add(_MessagesLoadedEvent(messages: messages)),
            (failure) => add(_ErrorEvent(failure: failure)),
          ));
    }

    on((event, emit) => onErrorCaught);
    on((event, emit) => onMessageLoaded);
  }
}
