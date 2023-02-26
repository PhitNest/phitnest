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
                          friendship.userCognitoIds.contains(friendCognitoId),
                    ),
                ),
                Cache.friendship.cacheFriendsAndMessages(
                  Cache.friendship.friendsAndMessages
                    ?..removeWhere(
                      (friendsAndMessages) =>
                          friendsAndMessages.friendship.userCognitoIds.contains(
                        friendCognitoId,
                      ),
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

  Either<Stream<Future<PopulatedFriendshipEntity>>, Failure> stream({
    required SocketConnection connection,
  }) =>
      Backend.friendship.stream(connection: connection).fold(
            (stream) => Left(
              stream.map(
                (friendship) => Future.wait(
                  [
                    Cache.friendship.cacheFriendsAndMessages(
                      Cache.friendship.friendsAndMessages
                        ?..removeWhere(
                          (conversations) =>
                              conversations.friendship.userCognitoIds
                                  .contains(friendship.userCognitoIds[0]) &&
                              conversations.friendship.userCognitoIds
                                  .contains(friendship.userCognitoIds[1]),
                        )
                        ..insert(
                          0,
                          FriendsAndMessagesResponse(
                            friendship: friendship,
                            message: null,
                          ),
                        ),
                    ),
                    Cache.friendship.cacheFriendsAndRequests(
                      Function.apply(
                        () {
                          final friendships =
                              Cache.friendship.friendsAndRequests?.friendships;
                          final requests =
                              Cache.friendship.friendsAndRequests?.requests;
                          if (friendships != null && requests != null) {
                            return FriendsAndRequestsResponse(
                              friendships: friendships
                                ..removeWhere(
                                  (element) =>
                                      element.userCognitoIds.contains(
                                          friendship.userCognitoIds[0]) &&
                                      element.userCognitoIds.contains(
                                          friendship.userCognitoIds[1]),
                                )
                                ..insert(
                                  0,
                                  friendship,
                                ),
                              requests: requests
                                ..removeWhere((element) =>
                                    friendship.userCognitoIds
                                        .contains(element.fromCognitoId) &&
                                    friendship.userCognitoIds
                                        .contains(element.toCognitoId)),
                            );
                          }
                        },
                        [],
                      ),
                    ),
                  ],
                ).then((_) => friendship),
              ),
            ),
            (failure) => Right(failure),
          );
}
