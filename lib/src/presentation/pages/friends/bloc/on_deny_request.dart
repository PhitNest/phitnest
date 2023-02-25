part of friends_page;

extension _OnDenyRequest on _FriendsBloc {
  void onDenyRequest(_DenyRequestEvent event, Emitter<_IFriendsState> emit) {
    if (state is _ILoadedState) {
      final state = this.state as _ILoadedState;
      emit(
        state.copyWith(
          denyingRequests: {
            ...state.denyingRequests,
            event.friend.id: CancelableOperation.fromFuture(
              authMethods.withAuthVoid(
                (accessToken) => Repositories.friendRequest.deny(
                  accessToken: accessToken,
                  senderCognitoId: event.friend.cognitoId,
                ),
              ),
            )..then(
                (failure) => add(
                  failure != null
                      ? _AddFriendErrorEvent(
                          friend: event.friend,
                          failure: failure,
                        )
                      : _AddFriendSuccessEvent(event.friend),
                ),
              ),
          },
        ),
      );
    }
  }
}
