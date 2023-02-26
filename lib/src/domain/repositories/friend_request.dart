part of repository;

class FriendRequest {
  const FriendRequest();

  Future<
      Either3<PopulatedFriendRequestEntity, PopulatedFriendshipEntity,
          Failure>> send({
    required String accessToken,
    required String recipientCognitoId,
  }) =>
      Backend.friendRequest
          .send(
        accessToken: accessToken,
        recipientCognitoId: recipientCognitoId,
      )
          .then(
        (either) {
          final removeFromExplore = () => Cache.user
              .cacheUserExplore(
                Cache.user.userExploreResponse
                  ?..removeWhere(
                    (user) => user.cognitoId == recipientCognitoId,
                  ),
              )
              .then((_) => null);
          return either.fold(
            (request) => removeFromExplore().then((_) => First(request)),
            (friendship) => Future.wait(
              [
                Cache.friendship.cacheFriendsAndRequests(
                  Cache.friendship.friendsAndRequests
                    ?..requests.removeWhere((request) =>
                        request.fromCognitoId == recipientCognitoId)
                    ..friendships.insert(0, friendship),
                ),
                Cache.friendship.cacheFriendsAndMessages(
                  (Cache.friendship.friendsAndMessages ?? [])
                    ..removeWhere((conversation) => conversation
                        .friendship.userCognitoIds
                        .contains(recipientCognitoId))
                    ..insert(
                      0,
                      FriendsAndMessagesResponse(
                        friendship: friendship,
                        message: null,
                      ),
                    ),
                ),
                removeFromExplore(),
              ],
            ).then((_) => Second(friendship)),
            (failure) => Third(failure),
          );
        },
      );

  Future<Failure?> deny({
    required String accessToken,
    required String senderCognitoId,
  }) =>
      Backend.friendRequest
          .deny(
        accessToken: accessToken,
        senderCognitoId: senderCognitoId,
      )
          .then(
        (failure) async {
          if (failure == null) {
            await Cache.friendship.cacheFriendsAndRequests(
              Cache.friendship.friendsAndRequests
                ?..requests.removeWhere(
                  (request) => request.fromCognitoId == senderCognitoId,
                ),
            );
            return null;
          }
          return failure;
        },
      );

  Either<Stream<Future<PopulatedFriendRequestEntity>>, Failure> stream({
    required SocketConnection connection,
  }) =>
      Backend.friendRequest.stream(connection: connection).fold(
            (stream) => Left(
              stream.map(
                (friendRequest) => Future.wait(
                  [
                    Cache.friendship.cacheFriendsAndMessages(
                      Cache.friendship.friendsAndMessages
                        ?..removeWhere(
                          (conversation) =>
                              conversation.friendship.userCognitoIds.contains(
                            friendRequest.fromCognitoId,
                          ),
                        ),
                    ),
                    Cache.friendship.cacheFriendsAndRequests(
                      Function.apply(
                        () {
                          final requests =
                              Cache.friendship.friendsAndRequests?.requests;
                          final friendships =
                              Cache.friendship.friendsAndRequests?.friendships;
                          if (requests != null && friendships != null) {
                            return FriendsAndRequestsResponse(
                              friendships: friendships
                                ..removeWhere(
                                  (friendship) =>
                                      friendship.userCognitoIds.contains(
                                    friendRequest.fromCognitoId,
                                  ),
                                ),
                              requests: requests
                                ..removeWhere(
                                  (element) =>
                                      element.fromCognitoId ==
                                          friendRequest.fromCognitoId &&
                                      element.toCognitoId ==
                                          friendRequest.fromCognitoId,
                                )
                                ..insert(0, friendRequest),
                            );
                          }
                        },
                        [],
                      ),
                    )
                  ],
                ).then((_) => friendRequest),
              ),
            ),
            (failure) => Right(failure),
          );
}
