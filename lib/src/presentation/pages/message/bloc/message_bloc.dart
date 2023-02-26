part of message;

class _MessageBloc extends Bloc<_IMessageEvent, _IMessageState> {
  final AuthMethods authMethods;
  final PopulatedFriendshipEntity friendship;
  final messageController = TextEditingController();
  final messageFocus = FocusNode();

  List<DirectMessageEntity>? get messages =>
      Cache.directMessage.getDirectMessages(
          friendship.notMe(Cache.user.user!.cognitoId).cognitoId);

  _MessageBloc({
    required this.authMethods,
    required this.friendship,
  }) : super(
          Function.apply(
            () {
              final loading = CancelableOperation.fromFuture(
                authMethods.withAuth(
                  (accessToken) => Repositories.directMessage.getDirectMessage(
                      accessToken: accessToken,
                      friendCognitoId: friendship
                          .notMe(Cache.user.user!.cognitoId)
                          .cognitoId),
                ),
              );
              return Cache.directMessage.getDirectMessages(friendship
                          .notMe(Cache.user.user!.cognitoId)
                          .cognitoId) ==
                      null
                  ? _LoadingState(
                      loadingMessage: loading,
                    )
                  : _ReloadingState(
                      loadingMessage: loading,
                    );
            },
            [],
          ),
        ) {
    on<_LoadedEvent>(onLoaded);
    on<_LoadingErrorEvent>(onLoadingError);
    on<_SendEvent>(onSend);
    on<_SendErrorEvent>(onSendError);
    on<_SendSuccessEvent>(onSendSuccess);
    if (state is _ILoadingState) {
      (state as _ILoadingState).loadingMessage.value.then(
            (either) => add(
              either.fold(
                (messages) => const _LoadedEvent(),
                (failure) => _LoadingErrorEvent(failure: failure),
              ),
            ),
          );
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
