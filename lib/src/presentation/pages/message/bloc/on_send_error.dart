part of message;

extension _OnSendError on _MessageBloc {
  void onSendError(_SendErrorEvent event, Emitter<_IMessageState> emit) {
    //   StyledErrorBanner.show(event.failure);
    //
    //   final op = CancelableOperation.fromFuture(
    //     authMethods.withAuth(
    //           (accessToken) =>
    //           Repositories.directMessage.getDirectMessage(
    //             accessToken: accessToken,
    //             friendCognitoId: friendship.friend.cognitoId,
    //           ),
    //     ),
    //   )
    //     ..then(
    //           (either) =>
    //           add(
    //             either.fold(
    //                   (messages) => const _LoadedEvent(),
    //                   (failure) => _LoadingErrorEvent(failure: failure),
    //             ),
    //           ),
    //     );
    //
    //   if (state is _ReloadingState) {
    //     emit(_ReloadingState(loadingMessage: op));
    //   } else {
    //     emit(_LoadingState(loadingMessage: op));
    //   }
  }
}
