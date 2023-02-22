part of cache;

class _FriendshipCache {
  static const kFriendsAndMessages = 'friendship.friendsAndMessages';

  const _FriendshipCache();

  List<FriendsAndMessagesResponse>? get friendsAndMessages =>
      getCachedList(kFriendsAndMessages, FriendsAndMessagesResponse.fromJson);

  Future<void> cacheFriendsAndMessages(
          List<FriendsAndMessagesResponse>? friendsAndMessages) =>
      cacheList(kFriendsAndMessages, friendsAndMessages);
}
