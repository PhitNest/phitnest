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
      bool inserted = false;
      for (int i = 0; i < Cache.friendship.friendsAndMessages!.length; i++) {
        final conversation = Cache.friendship.friendsAndMessages![i];
        final conversationDateA = conversation.message != null
            ? conversation.message!.createdAt
            : conversation.friendship.createdAt;
        final conversationDateB = event.conversation.message != null
            ? event.conversation.message!.createdAt
            : event.conversation.friendship.createdAt;
        if (conversationDateA.isBefore(conversationDateB)) {
          Cache.friendship.friendsAndMessages!.insert(i, event.conversation);
          inserted = true;
          break;
        }
      }
      if (!inserted) {
        Cache.friendship.friendsAndMessages!.add(event.conversation);
      }
      await Cache.friendship
          .cacheFriendsAndMessages(Cache.friendship.friendsAndMessages!);
    }
    if (state is _ChatLoadedState) {
      emit(const _ChatLoadedState());
    } else if (state is _ChatLoadingState) {
      final state = this.state as _ChatLoadingState;
      emit(
        _ChatLoadingState(
          conversations: state.conversations,
        ),
      );
    } else if (state is _ChatReloadingState) {
      final state = this.state as _ChatReloadingState;
      emit(
        _ChatReloadingState(
          conversations: state.conversations,
        ),
      );
    }
  }
}
