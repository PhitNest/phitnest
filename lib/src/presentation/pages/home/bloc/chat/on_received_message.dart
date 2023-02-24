part of home_page;

extension _ChatOnReceivedMessage on _ChatBloc {
  void onReceivedMessage(
      _ChatReceivedMessageEvent event, Emitter<_IChatState> emit) async {
    Cache.friendship.friendsAndMessages?.removeWhere(
      (conversation) =>
          conversation.friendship.id == event.conversation.friendship.id,
    );
    if (Cache.friendship.friendsAndMessages == null) {
      await Cache.friendship.cacheFriendsAndMessages([event.conversation]);
    } else {
      Cache.friendship.friendsAndMessages!.insert(
        0,
        event.conversation,
      );
    }
    emit(state);
  }
}
