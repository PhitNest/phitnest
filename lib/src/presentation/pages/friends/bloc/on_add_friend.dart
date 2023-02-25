part of friends_page;

extension _OnAddFriend on _FriendsBloc {
  void onAddFriend(_AddFriendEvent event, Emitter<_IFriendsState> emit) {
    if (state is _ILoadedState) {
      final state = this.state as _ILoadedState;
      emit(
        state.copyWith(
          sendingRequests: {
            ...state.sendingRequests,
            event.friend.id: CancelableOperation.fromFuture(
              authMethods.withAuthEither3(
                (accessToken) => Repositories.friendRequest.send(
                  accessToken: accessToken,
                  recipientCognitoId: event.friend.cognitoId,
                ),
              ),
            )..then(
                (res) => add(
                  res.fold(
                    (request) => _AddFriendErrorEvent(
                      friend: event.friend,
                      failure: Failures.invalidBackendResponse.instance,
                    ),
                    (friendship) => _AddFriendSuccessEvent(event.friend),
                    (failure) => _AddFriendErrorEvent(
                      friend: event.friend,
                      failure: failure,
                    ),
                  ),
                ),
              ),
          },
        ),
      );
    }
  }
}
