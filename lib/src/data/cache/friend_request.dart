part of cache;

FriendRequestEntity? _getFriendRequest(String id) {
  final fromCognitoId = _getString("${_Keys.friendRequestFromCognitoId}.$id");
  final toCognitoId = _getString("${_Keys.friendRequestToCognitoId}.$id");
  final denied = _getBool("${_Keys.friendRequestDenied}.$id");
  final createdAt = _getDateTime("${_Keys.friendRequestCreatedAt}.$id");
  if (fromCognitoId != null &&
      toCognitoId != null &&
      denied != null &&
      createdAt != null) {
    return FriendRequestEntity(
      id: id,
      fromCognitoId: fromCognitoId,
      toCognitoId: toCognitoId,
      denied: denied,
      createdAt: createdAt,
    );
  } else {
    return null;
  }
}

Future<bool> _cacheFriendRequest(
        String id, FriendRequestEntity? friendRequest) =>
    Future.wait([
      _cacheString("${_Keys.friendRequestFromCognitoId}.$id",
          friendRequest?.fromCognitoId),
      _cacheString(
          "${_Keys.friendRequestToCognitoId}.$id", friendRequest?.toCognitoId),
      _cacheBool("${_Keys.friendRequestDenied}.$id", friendRequest?.denied),
      _cacheDateTime(
          "${_Keys.friendRequestCreatedAt}.$id", friendRequest?.createdAt),
    ]).then((_) => true);
