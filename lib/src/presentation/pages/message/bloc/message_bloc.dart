part of message;

class _MessageBloc extends Bloc<_IMessageEvent, _IMessageState> {
  final AuthMethods authMethods;
  final PopulatedFriendshipEntity friendship;

  List<DirectMessageEntity>? get messages =>
      Cache.directMessage.getDirectMessages(friendship.friend.cognitoId);

  _MessageBloc({
    required this.authMethods,
    required this.friendship,
  }) : super(
          Function.apply(
            () {
              final directMessage = CancelableOperation.fromFuture(
                authMethods.withAuth(
                  (accessToken) => Repositories.directMessage.getDirectMessage(
                    accessToken: accessToken,
                    friendCognitoId: friendship.friend.cognitoId,
                  ),
                ),
              );
              return Cache.directMessage
                          .getDirectMessages(friendship.friend.cognitoId) ==
                      null
                  ? _LoadingState(
                      loadingMessage: CancelableOperation.fromFuture(
                        authMethods.withAuth(
                          (accessToken) => Repositories.directMessage
                              .getDirectMessage(
                                  accessToken: accessToken,
                                  friendCognitoId: friendship.friend.cognitoId),
                        ),
                      ),
                    )
                  : const _LoadedState();
            },
            [],
          ),
        ) {
    if (state is _LoadingState) {
      (state as _LoadingState).loadingMessage.value.then(
            (either) => add(
              either.fold(
                (messages) => const _LoadedEvent(),
                (failure) => _LoadingErrorEvent(failure: failure),
              ),
            ),
          );

      on<_LoadedEvent>(onLoaded);
      on<_LoadingErrorEvent>(onLoadingError);
      on<_SendEvent>(onSend);
      on<_SendErrorEvent>(onSendError);
      on<_SendSuccessEvent>(onSendSuccess);
    }
  }
}

extension _MessageBlocExt on BuildContext {
  _MessageBloc get bloc => read();
}
