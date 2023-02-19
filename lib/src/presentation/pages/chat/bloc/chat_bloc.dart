part of chat_page;

class _ChatBloc extends Bloc<_IChatEvent, _IChatState> {
  final Future<Either<T, Failure>> Function<T>(
      Future<Either<T, Failure>> Function(String accessToken) f) withAuth;
  final Future<Failure?> Function(
      Future<Failure?> Function(String accessToken) f) withAuthVoid;

  _ChatBloc({
    required this.withAuth,
    required this.withAuthVoid,
  }) : super(
          _InitialState(
            loadingMessages: CancelableOperation.fromFuture(
              withAuth(
                (accessToken) =>
                    Backend.friendship.friendsAndMessages(accessToken),
              ),
            ),
          ),
        ) {
    if (state is _InitialState) {
      final _InitialState state = this.state as _InitialState;
      state.loadingMessages.then(
        (value) => value.fold(
          (messages) => add(_MessagesLoadedEvent(messages: messages)),
          (failure) => add(_ErrorEvent(failure: failure)),
        ),
      );
    }

    on<_ErrorEvent>(onErrorCaught);
    on<_MessagesLoadedEvent>(onMessageLoaded);
  }

  @override
  Future<void> close() {
    if (state is _ErrorState) {
      final _ErrorState state = this.state as _ErrorState;
      state.errorBanner.dismiss();
    }
    return super.close();
  }
}
