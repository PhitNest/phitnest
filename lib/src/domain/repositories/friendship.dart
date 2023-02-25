part of repository;

class Friendship {
  const Friendship();

  Future<Either<List<FriendsAndMessagesResponse>, Failure>> friendsAndMessages(
    String accessToken,
  ) =>
      Backend.friendship.friendsAndMessages(accessToken).then(
            (either) => either.fold(
              (response) =>
                  Cache.friendship.cacheFriendsAndMessages(response).then(
                        (_) => Left(response),
                      ),
              (failure) => Right(failure),
            ),
          );

  Future<Either<FriendsAndRequestsResponse, Failure>> friendsAndRequests(
    String accessToken,
  ) =>
      Backend.friendship.friendsAndRequests(accessToken).then(
            (either) => either.fold(
              (response) =>
                  Cache.friendship.cacheFriendsAndRequests(response).then(
                        (_) => Left(response),
                      ),
              (failure) => Right(failure),
            ),
          );

  Future<Failure?> removeFriend({
    required String accessToken,
    required String friendCognitoId,
  }) =>
      Backend.friendship
          .remove(
        accessToken: accessToken,
        friendCognitoId: friendCognitoId,
      )
          .then(
        (failure) {
          if (failure == null) {
            return Future.wait(
              [
                Cache.friendship.cacheFriendsAndRequests(
                  Cache.friendship.friendsAndRequests
                    ?..friendships.removeWhere(
                      (friendship) =>
                          friendship.friend.cognitoId == friendCognitoId,
                    ),
                ),
                Cache.friendship.cacheFriendsAndMessages(
                  Cache.friendship.friendsAndMessages
                    ?..removeWhere(
                      (friendsAndMessages) =>
                          friendsAndMessages.friendship.friend.cognitoId ==
                          friendCognitoId,
                    ),
                ),
              ],
            ).then(
              (_) => null,
            );
          }
          return failure;
        },
      );
}
