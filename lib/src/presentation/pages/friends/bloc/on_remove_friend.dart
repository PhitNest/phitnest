part of friends_page;

extension _OnRemoveFriend on _FriendsBloc {
  void onRemoveFriend(_RemoveFriendEvent event, Emitter<_IFriendsState> emit) {
    if (state is _ILoadedState) {
      final state = this.state as _ILoadedState;
      emit(
        state.copyWith(
          removingFriends: {
            ...state.removingFriends,
            event.friend.id: CancelableOperation.fromFuture(
              authMethods.withAuthVoid(
                (accessToken) => Repositories.friendship.removeFriend(
                  accessToken: accessToken,
                  friendCognitoId: event.friend.cognitoId,
                ),
              ),
            )..then(
                (failure) => add(
                  failure != null
                      ? _RemoveFriendErrorEvent(
                          friend: event.friend, failure: failure)
                      : _RemoveFriendSuccessEvent(event.friend),
                ),
              ),
          },
        ),
      );
    }
  }
}
