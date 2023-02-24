part of cache;

class _FriendshipCache {
  static const kFriendsAndMessages = 'friendship.friendsAndMessages';
  static const kFriendsAndRequests = 'friendship.friendsAndRequests';

  const _FriendshipCache();

  List<FriendsAndMessagesResponse>? get friendsAndMessages =>
      getCachedList(kFriendsAndMessages, FriendsAndMessagesResponse.fromJson);

  Future<void> cacheFriendsAndMessages(
    List<FriendsAndMessagesResponse>? friendsAndMessages,
  ) =>
      cacheList(kFriendsAndMessages, friendsAndMessages);

  FriendsAndRequestsResponse? get friendsAndRequests =>
      getCachedObject(kFriendsAndRequests, FriendsAndRequestsResponse.fromJson);

  Future<void> cacheFriendsAndRequests(
    FriendsAndRequestsResponse? friendsAndRequests,
  ) =>
      cacheObject(kFriendsAndRequests, friendsAndRequests);
}
