part of friends_page;

extension _OnLoaded on _FriendsBloc {
  void onLoaded(_LoadedEvent event, Emitter<_IFriendsState> emit) {
    Map<
            String,
            CancelableOperation<
                Either3<FriendRequestEntity, FriendshipEntity, Failure>>>
        sendingRequests = {};
    Map<String, CancelableOperation<Failure?>> denyingRequests = {};
    Map<String, CancelableOperation<Failure?>> removingFriends = {};
    if (state is _LoadedState) {
      final state = this.state as _LoadedState;
      sendingRequests = state.sendingRequests;
      denyingRequests = state.denyingRequests;
      removingFriends = state.removingFriends;
    }
    emit(
      _LoadedState(
        sendingRequests: sendingRequests,
        denyingRequests: denyingRequests,
        removingFriends: removingFriends,
      ),
    );
  }
}
