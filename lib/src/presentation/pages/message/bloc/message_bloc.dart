part of message;

class _MessageBloc extends Bloc<_IMessageEvent, _IMessageState> {
  final AuthMethods authMethods;
  final PopulatedFriendshipEntity friendship;
  final messageController = TextEditingController();
  final messageFocus = FocusNode();

  List<DirectMessageEntity>? get messages =>
      Cache.directMessage.getDirectMessages(friendship.friend.cognitoId);

  _MessageBloc({
    required this.authMethods,
    required this.friendship,
  }) : super(
          Cache.directMessage.getDirectMessages(friendship.friend.cognitoId) ==
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
              : const _LoadedState(),
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

  @override
  Future<void> close() async {
    messageController.dispose();
    messageFocus.dispose();
    if (state is _ILoadingState) {
      final state = this.state as _LoadingState;
      await state.loadingMessage.cancel();
    }
    if (state is _SendingState) {
      final state = this.state as _SendingState;
      await state.sending.cancel();
    }
    return super.close();
  }
}

extension _MessageBlocExt on BuildContext {
  _MessageBloc get bloc => read();
}
