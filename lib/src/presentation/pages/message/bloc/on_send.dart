part of message;

extension _OnSend on _MessageBloc {
  void onSend(_SendEvent event, Emitter<_IMessageState> emit) {
    if (messageController.text.trim().isNotEmpty) {
      emit(
        _SendingState(
          sending: CancelableOperation.fromFuture(
            Repositories.directMessage.send(
              connection: event.connection,
              recipientCognitoId: friendship.friend.cognitoId,
              text: messageController.text.trim(),
            ),
          )..then(
              (res) => add(
                res.fold(
                  (success) => const _SendSuccessEvent(),
                  (failure) => _SendErrorEvent(failure: failure),
                ),
              ),
            ),
        ),
      );
      messageFocus.unfocus();
      messageController.clear();
    }
  }
}
